# Architecture draft

This project is independent of EntityCraft. Detailed product scope (access library, ORM, or schema/code generation toolkit) remains to be agreed. This scaffold covers only the common database boundary.

## Layers

1. Core: values, connection and statement contracts, ownership and capabilities.
2. Drivers: SQLite, PostgreSQL, later other relational databases. Vendor dependencies stay private.
3. SQL dialect: quoting, placeholders, type mappings and supported syntax; introduced when portable queries are designed.
4. Higher-level features: entity mapping, schema inspection, code generation and migrations are separate future decisions.

Cross-platform operation means CMake targets without global compiler flags or platform path assumptions, portable standard types and independent CI builds on Linux, Windows and macOS. Native implementation details belong inside drivers. A stable binary plugin ABI is not promised; initially drivers will be ordinary build-time components.

## Initial contract

Connections are thread-confined. Drivers create independently owned connections. Statements bind copied values using zero-based indices, execute once and return rows until exhausted. SQL currently uses the backend's native syntax; common interfaces do not make SQL portable. Connection must outlive statements; real drivers must enforce safe lifetime behavior. Ownership could change before a driver ships.

Transactions are explicit and gated by capabilities. Unsupported operations must fail explicitly. Exact exceptions and backend error metadata still require design. Savepoint support is a capability placeholder, not an implemented API.

NULL is monostate, distinct from empty strings and blobs. Exact decimal, temporal, unsigned and backend-specific values are unresolved; do not silently coerce them into double or string.

## Why two initial backends

SQLite exercises embedded deployment and easy isolated tests. PostgreSQL then exercises network connections, different placeholders and types. Shared behavioral tests plus backend-specific tests will expose assumptions in the common API.

## Open decisions

License, minimum compiler versions, precise product scope, error taxonomy, statement lifetime and value coverage. C++17 is a starting choice, not a requirement inferred from the author's existing C++14 projects.
