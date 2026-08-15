# Accessibility Verification Checklist

Automated checks alone do not demonstrate WCAG conformity. Record automated and manual evidence for every affected change.

## Scope and Ownership

- Change/routes/components:
- Reviewer:
- Review date:
- Retest date:
- WCAG target: 2.2 Level AA
- EN 301 549 applicability notes:
- Real Decreto 193/2023 applicability owner:
- Ley 11/2023 applicability owner:
- Unresolved barriers and owners:

## Automated Checks

- Command and result:
- Pages and states covered:
- Known tool limitations:

## Keyboard

- [ ] All functionality works without a pointer.
- [ ] Focus order is logical, visible, and unobscured.
- [ ] No keyboard trap exists.
- [ ] Modals, menus, galleries, filters, and consent controls manage focus correctly.

## Screen reader

- Browser/screen-reader combination:
- Flows covered:
- [ ] Names, roles, values, states, labels, errors, and status messages are announced correctly.
- Findings:

## Zoom and reflow

- [ ] Text remains usable at 200 percent resize.
- [ ] Content reflows at 320 CSS pixels without prohibited two-dimensional scrolling.
- [ ] Responsive layouts preserve content, controls, and reading order.

## Visual and Interaction

- [ ] Text, UI, graphics, focus, and state contrasts meet applicable WCAG requirements.
- [ ] Color is not the only means of conveying information.
- [ ] Target size, motion, orientation, hover, and focus content meet applicable criteria.

## Forms and validation

- [ ] Labels, instructions, required state, errors, and suggestions are programmatic and understandable.
- [ ] Errors are announced, associated with fields, and not color-only.
- [ ] Complete processes remain operable and recoverable.

## Multimedia

- [ ] Required captions, transcripts, audio descriptions, controls, and motion alternatives exist.

## Dynamic Components

- [ ] Galleries, filters, modals, menus, carousels, and live updates preserve keyboard/focus behavior.
- [ ] Dynamic status is exposed without unexpected context changes.

## Maps and plans

- [ ] Equivalent text, list, table, directions, search, or assisted-contact alternatives exist.
- [ ] Interactive maps/plans have appropriate labels, keyboard behavior, contrast, and zoom support.

## Result

- [ ] No unresolved blocking accessibility regression remains.
- Residual risks accepted by:
- Follow-up issue/change:
