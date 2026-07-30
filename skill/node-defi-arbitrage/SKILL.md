---
name: node-defi-arbitrage
description: Use ONLY to provide reusable Node.js and TypeScript context for DeFi arbitrage, DEX integrations, blockchain RPC, transaction simulation, and on-chain execution.
---

# Node DeFi Arbitrage Context

Apply this context when designing, implementing, testing, or reviewing a Node.js/TypeScript DeFi arbitrage system. Project documentation and OpenSpec artifacts override project-specific choices.

## Technology Baseline

1. Use TypeScript with strict compiler settings on a supported Node.js LTS release.
2. Prefer `viem` for EVM RPC, ABI, transaction, and unit handling unless the project selects an equivalent library.
3. Support HTTP RPC for reads, simulations, and submission, and WebSocket RPC for low-latency block or event notifications when required.
4. Validate data received from RPC providers, indexers, quote APIs, and configuration boundaries.

## Conceptual Boundaries

Keep protocol-specific and chain-specific details behind adapters so that domain logic is portable:

1. Opportunity discovery and route evaluation.
2. Quote, cost, and profitability calculation.
3. Transaction simulation and execution.
4. DEX or protocol adapters.
5. Chain and RPC adapters.

Do not couple core opportunity logic directly to one DEX SDK, blockchain, or RPC vendor.

## Numeric Correctness

1. Never use JavaScript `number` for execution amounts, token reserves, gas costs, fees, or profit decisions.
2. Represent on-chain amounts in token base units with `bigint`.
3. Preserve token decimals and rounding direction explicitly at every conversion boundary.
4. Use an arbitrary-precision decimal library only for off-chain ratios, analytics, or display; never convert execution amounts through floating point.
5. Evaluate profit after relevant execution costs rather than from quoted price differences alone.

## Quotes and Execution Semantics

1. Treat a quote as a time-sensitive estimate associated with a chain, block or state snapshot, route, and observation time.
2. Simulate the exact transaction against recent chain state before submission when the network supports it.
3. A successful quote or simulation does not guarantee inclusion or profit because state can change before execution.
4. Keep opportunity detection separate from transaction construction and execution.

## Atomic and Cross-Chain Arbitrage

1. Same-chain routes can use an executor contract to perform all steps atomically and revert when an on-chain minimum-profit or minimum-output condition fails.
2. A reverted transaction still consumes gas, and a confirmed successful transaction cannot be undone later.
3. Operations spanning independent blockchains are not generally atomic; model partial execution, bridge delay, inventory, and price risk explicitly.

## Blockchain Reliability

1. Treat WebSocket notifications as hints rather than a complete event history.
2. Account for reconnects, duplicate or missing events, stale data, reorgs, transaction replacement, and chain-specific finality.
3. Treat submission timeouts as unknown outcomes and reconcile before retrying.
4. Assume transactions in public mempools can be observed and competed against; consider network-appropriate MEV protection where relevant.

## Testing Context

For behavior changes, follow RED -> GREEN -> REFACTOR.

Useful complementary validation techniques are:

1. Unit and property tests for numeric and routing logic.
2. Deterministic mainnet-fork tests against real deployed contract state.
3. Historical backtesting using past chain state when available.
4. Shadow or paper mode using live data without broadcasting transactions.

Do not assume public testnet liquidity represents mainnet liquidity or arbitrage performance.

## Security Baseline

1. Never commit or log private keys, seed phrases, signed raw transactions, or provider credentials.
2. Separate observation, simulation, and live-execution modes.
3. Require explicit project configuration before enabling live execution.
4. The development agent must not deploy contracts, fund wallets, sign live transactions, or broadcast public-network transactions without explicit operator authorization.

## Project-Owned Decisions

Do not invent these values in the skill. Read them from the consuming project's documentation, configuration, or OpenSpec artifacts:

- supported blockchains, DEXs, protocols, tokens, and contract addresses;
- same-chain, multichain, or cross-chain strategy;
- flash-loan and executor-contract design;
- RPC providers, indexers, relays, and MEV strategy;
- persistence, deployment, hosting, and observability;
- capital, gas, slippage, profit, loss, and circuit-breaker limits;
- exact build, test, simulation, and deployment commands.
