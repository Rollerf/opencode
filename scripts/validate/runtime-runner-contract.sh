#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

fail() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

assert_contains() {
  local text="$1"
  local expected="$2"
  [[ "$text" == *"$expected"* ]] || fail "Expected output to contain: $expected"
}

assert_not_contains() {
  local text="$1"
  local unexpected="$2"
  [[ "$text" != *"$unexpected"* ]] || fail "Expected output not to contain: $unexpected"
}

assert_before() {
  local file="$1"
  local first="$2"
  local second="$3"
  local first_line second_line
  first_line="$(grep -nF "$first" "$file" | head -n1 | cut -d: -f1)"
  second_line="$(grep -nF "$second" "$file" | head -n1 | cut -d: -f1)"
  [[ -n "$first_line" && -n "$second_line" && "$first_line" -lt "$second_line" ]] ||
    fail "Expected '$first' before '$second' in $file"
}

run_expect_failure() {
  local output status
  set +e
  output="$("$@" 2>&1)"
  status=$?
  set -e
  [[ $status -ne 0 ]] || fail "Expected command to fail: $*"
  printf '%s' "$output"
}

RESOLVER=(node "${ROOT_DIR}/scripts/resolve-pack.mjs" --module-dir "$ROOT_DIR")
SOURCE_CHANGE="harden-opencode-runtime-definitions"
if [[ ! -d "${ROOT_DIR}/openspec/changes/${SOURCE_CHANGE}" ]]; then
  shopt -s nullglob
  archived_changes=("${ROOT_DIR}"/openspec/changes/archive/*-"${SOURCE_CHANGE}")
  ((${#archived_changes[@]} > 0)) || fail "Missing source or archived fixture change: ${SOURCE_CHANGE}"
  SOURCE_CHANGE="archive/$(basename "${archived_changes[-1]}")"
fi

doctor_output="$("${ROOT_DIR}/opencode-runner.sh" doctor 2>&1)"
assert_contains "$doctor_output" "openspec command found: ${ROOT_DIR}/node_modules/.bin/openspec"
assert_contains "$doctor_output" '(1.1.1)'

mkdir -p "$TMP_DIR/unique" "$TMP_DIR/ambiguous" "$TMP_DIR/unsupported" "$TMP_DIR/confirmed" "$TMP_DIR/stale"
printf '{"dependencies":{"@angular/core":"latest"}}\n' > "$TMP_DIR/unique/package.json"
printf '{}\n' > "$TMP_DIR/unique/angular.json"
cp "$TMP_DIR/unique/package.json" "$TMP_DIR/ambiguous/package.json"
cp "$TMP_DIR/unique/angular.json" "$TMP_DIR/ambiguous/angular.json"
printf 'module fixture\n\nrequire github.com/aws/aws-sdk-go/v2 v2.0.0\n' > "$TMP_DIR/ambiguous/go.mod"
cp -R "$TMP_DIR/unique/." "$TMP_DIR/confirmed/"
printf 'default_pack: angular\nallowed_packs: [angular, generic]\n' > "$TMP_DIR/confirmed/.opencode-project.yaml"
printf 'default_pack: angular\n' > "$TMP_DIR/stale/.opencode-project.yaml"

output="$("${RESOLVER[@]}" --project-root "$TMP_DIR/unique" 2>&1)"
assert_contains "$output" 'Pack selected: angular (project evidence)'
assert_contains "$output" 'angular.json'

output="$("${RESOLVER[@]}" --project-root "$TMP_DIR/confirmed" 2>&1)"
assert_contains "$output" 'Pack selected: angular (confirmed project configuration)'

output="$("${RESOLVER[@]}" --project-root "$TMP_DIR/stale" --pack generic 2>&1)"
assert_contains "$output" 'Pack selected: generic (explicit --pack)'

output="$(run_expect_failure "${RESOLVER[@]}" --project-root "$TMP_DIR/ambiguous")"
assert_contains "$output" 'Multiple stack packs match'
assert_contains "$output" 'angular'
assert_contains "$output" 'go-aws'
assert_contains "$output" 'confirm one with --pack'

output="$(run_expect_failure "${RESOLVER[@]}" --project-root "$TMP_DIR/unsupported")"
assert_contains "$output" 'No stack pack matches'
assert_contains "$output" 'explicitly confirm generic'
assert_contains "$output" 'new pack definition'

output="$(run_expect_failure "${RESOLVER[@]}" --project-root "$TMP_DIR/stale")"
assert_contains "$output" 'Confirmed pack angular is stale or incompatible'

output="$(run_expect_failure "${RESOLVER[@]}" --project-root "$TMP_DIR/unsupported" --pack missing-pack)"
assert_contains "$output" 'Unknown pack: missing-pack'

SOURCE_BUNDLE="$TMP_DIR/source-bundle.md"
output="$("${ROOT_DIR}/opencode-runner.sh" bundle --phase implementation \
  --change "$SOURCE_CHANGE" --pack generic --skills openspec-workflow \
  --user-prompt 'SOURCE_GOAL' --out "$SOURCE_BUNDLE" 2>&1)"
assert_contains "$output" 'Bundle lines:'
assert_contains "$output" 'Bundle bytes:'
assert_contains "$output" 'Approximate tokens:'
source_content="$(<"$SOURCE_BUNDLE")"
assert_contains "$source_content" "Project root: \`$ROOT_DIR\`"
assert_contains "$source_content" 'Pack Contract: generic/pack.yaml'
assert_contains "$source_content" 'Change Artifact: design.md'
assert_contains "$source_content" 'Change Artifact: tasks.md'
assert_not_contains "$source_content" 'Change Artifact: proposal.md'
assert_before "$SOURCE_BUNDLE" '## User Goal' '## Generated Context'

GLOBAL_CONSUMER="$TMP_DIR/global-consumer"
GLOBAL_CHANGE="global-fixture-change"
mkdir -p "$GLOBAL_CONSUMER/openspec/changes/$GLOBAL_CHANGE/specs/example"
printf 'GLOBAL_PROPOSAL_ONLY\n' > "$GLOBAL_CONSUMER/openspec/changes/$GLOBAL_CHANGE/proposal.md"
printf 'GLOBAL_DESIGN_ONLY\n' > "$GLOBAL_CONSUMER/openspec/changes/$GLOBAL_CHANGE/design.md"
printf 'GLOBAL_TASKS_ONLY\n' > "$GLOBAL_CONSUMER/openspec/changes/$GLOBAL_CHANGE/tasks.md"
printf 'GLOBAL_SPEC_ONLY\n' > "$GLOBAL_CONSUMER/openspec/changes/$GLOBAL_CHANGE/specs/example/spec.md"

GLOBAL_BUNDLE="$TMP_DIR/global-bundle.md"
output="$(cd "$GLOBAL_CONSUMER" && "$ROOT_DIR/opencode-runner.sh" bundle --phase verification \
  --change "$GLOBAL_CHANGE" --pack generic --skills openspec-workflow --out "$GLOBAL_BUNDLE" 2>&1)"
global_content="$(<"$GLOBAL_BUNDLE")"
assert_contains "$output" 'Pack selected: generic (explicit --pack)'
assert_contains "$global_content" "Module directory: \`$ROOT_DIR\`"
assert_contains "$global_content" "Project root: \`$GLOBAL_CONSUMER\`"
assert_contains "$global_content" 'GLOBAL_DESIGN_ONLY'
assert_contains "$global_content" 'GLOBAL_TASKS_ONLY'
assert_contains "$global_content" 'GLOBAL_SPEC_ONLY'
assert_not_contains "$global_content" 'GLOBAL_PROPOSAL_ONLY'

CONSUMER="$TMP_DIR/consumer"
MODULE="$CONSUMER/.opencode"
mkdir -p "$MODULE/scripts" "$MODULE/agents" "$MODULE/skill/test-skill/references" "$CONSUMER/openspec/changes/fixture-change/specs/example" "$CONSUMER/openspec/changes/fixture-change/evidence"
cp "$ROOT_DIR/opencode-runner.sh" "$MODULE/opencode-runner.sh"
cp "$ROOT_DIR/scripts/resolve-pack.mjs" "$MODULE/scripts/resolve-pack.mjs"
cp -R "$ROOT_DIR/packs" "$MODULE/packs"
ln -s "$ROOT_DIR/node_modules" "$MODULE/node_modules"
printf '%s\n' '---' 'description: fixture orchestrator' '---' '' 'FIXTURE_AGENT_BODY' > "$MODULE/agents/orchestrator.md"
printf '%s\n' '---' 'name: test-skill' 'description: fixture skill' '---' '' 'FIXTURE_SKILL_BODY' > "$MODULE/skill/test-skill/SKILL.md"
printf 'UNIQUE_REFERENCE_BODY\n' > "$MODULE/skill/test-skill/references/detail.md"
printf 'PROPOSAL_ONLY\n' > "$CONSUMER/openspec/changes/fixture-change/proposal.md"
printf 'DESIGN_ONLY\n`````embedded`````\n' > "$CONSUMER/openspec/changes/fixture-change/design.md"
printf 'TASKS_ONLY\n' > "$CONSUMER/openspec/changes/fixture-change/tasks.md"
printf 'SPEC_ONLY\n' > "$CONSUMER/openspec/changes/fixture-change/specs/example/spec.md"
printf 'EVIDENCE_ONLY\n' > "$CONSUMER/openspec/changes/fixture-change/evidence/report.md"
printf '{"dependencies":{"@angular/core":"latest"}}\n' > "$CONSUMER/package.json"
printf '{}\n' > "$CONSUMER/angular.json"

CONSUMER_BUNDLE="$TMP_DIR/consumer-bundle.md"
output="$("$MODULE/opencode-runner.sh" bundle --phase verification --change fixture-change \
  --skills test-skill --user-prompt $'CONSUMER_GOAL\n```nested```' --out "$CONSUMER_BUNDLE" 2>&1)"
consumer_content="$(<"$CONSUMER_BUNDLE")"
assert_contains "$output" 'Pack selected: angular (project evidence)'
assert_contains "$consumer_content" "Module directory: \`$MODULE\`"
assert_contains "$consumer_content" "Project root: \`$CONSUMER\`"
assert_contains "$consumer_content" 'FIXTURE_AGENT_BODY'
assert_contains "$consumer_content" 'FIXTURE_SKILL_BODY'
assert_contains "$consumer_content" 'Pack Contract: angular/pack.yaml'
assert_contains "$consumer_content" 'Keep container components thin'
assert_contains "$consumer_content" 'DESIGN_ONLY'
assert_contains "$consumer_content" 'TASKS_ONLY'
assert_contains "$consumer_content" 'SPEC_ONLY'
assert_not_contains "$consumer_content" 'PROPOSAL_ONLY'
assert_not_contains "$consumer_content" 'EVIDENCE_ONLY'
assert_not_contains "$consumer_content" 'UNIQUE_REFERENCE_BODY'
assert_contains "$consumer_content" 'Available Skill References'
assert_contains "$consumer_content" 'detail.md'
assert_contains "$consumer_content" '````text'
assert_contains "$consumer_content" '``````md'
assert_before "$CONSUMER_BUNDLE" '## User Goal' '## Generated Context'

REFERENCE_BUNDLE="$TMP_DIR/reference-bundle.md"
"$MODULE/opencode-runner.sh" bundle --phase planning --change fixture-change --pack angular \
  --skills test-skill --references --out "$REFERENCE_BUNDLE" >/dev/null 2>&1
reference_content="$(<"$REFERENCE_BUNDLE")"
assert_contains "$reference_content" 'UNIQUE_REFERENCE_BODY'
[[ "$(grep -Fc 'UNIQUE_REFERENCE_BODY' "$REFERENCE_BUNDLE")" -eq 1 ]] || fail 'Reference body was embedded more than once'

NO_REFERENCE_BUNDLE="$TMP_DIR/no-reference-bundle.md"
"$MODULE/opencode-runner.sh" bundle --phase planning --change fixture-change --pack angular \
  --skills test-skill --references --no-references --out "$NO_REFERENCE_BUNDLE" >/dev/null 2>&1
assert_not_contains "$(<"$NO_REFERENCE_BUNDLE")" 'UNIQUE_REFERENCE_BODY'

ARCHIVE_BUNDLE="$TMP_DIR/archive-bundle.md"
"$MODULE/opencode-runner.sh" bundle --phase archive --change fixture-change --pack angular \
  --skills test-skill --out "$ARCHIVE_BUNDLE" >/dev/null 2>&1
archive_content="$(<"$ARCHIVE_BUNDLE")"
assert_contains "$archive_content" 'PROPOSAL_ONLY'
assert_contains "$archive_content" 'TASKS_ONLY'
assert_contains "$archive_content" 'SPEC_ONLY'
assert_contains "$archive_content" 'EVIDENCE_ONLY'
assert_not_contains "$archive_content" 'DESIGN_ONLY'

output="$("$MODULE/opencode-runner.sh" phase implementation --change fixture-change --pack angular --dry-run 2>&1)"
assert_contains "$output" 'Agent: orchestrator'
assert_contains "$output" 'Phase skill: openspec-implementation'
assert_contains "$output" 'openspec instructions apply --change fixture-change --json'

echo 'Runtime runner contract passed'
