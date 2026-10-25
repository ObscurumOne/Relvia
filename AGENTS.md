# Project instructions

Build an independent open-source C++ database library. Read README.md and docs/architecture.md before changing public interfaces.

- Baseline: C++17, CMake 3.20+, Linux/Windows/macOS; no Qt dependency in core.
- Prefer auto when the initializer makes the type clear. Keep formatting compact and readable.
- Keep vendor headers, native handles and SQL dialect assumptions out of common interfaces.
- Drivers are separate opt-in components. Never claim a backend is supported until real integration tests pass.
- Use RAII and explicit ownership. Never concatenate user values into SQL; use parameter binding.
- No silent conversions, truncated values, hidden reconnects or implicit cross-thread connection sharing.
- Public API is provisional. Document lifetimes, error behavior and capability differences.
- Do not introduce an ORM, migrations, async execution or connection pool before the first driver works.
- Do not store credentials or log connection strings. Do not copy EntityCraft code.
- Explain technical decisions in Russian; code identifiers and public documentation may use English.

Validation:
```sh
cmake -S . -B build -DBUILD_TESTING=ON
cmake --build build --config Debug
ctest --test-dir build -C Debug --output-on-failure
```
Report checks actually performed and missing tooling. For driver changes, add meaningful backend integration tests. Cross-platform CI results must not be inferred from Linux checks.
