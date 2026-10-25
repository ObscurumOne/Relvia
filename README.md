# Relvia

Independent open-source C++ database library scaffold. C++17, CMake 3.20+, Linux / Windows / macOS are the intended baseline.

**Status:** experimental interface scaffold only. No working database drivers, ORM or schema tools yet. API is provisional.

## Build

```sh
cmake -S . -B build -DBUILD_TESTING=ON
cmake --build build --config Debug
ctest --test-dir build -C Debug --output-on-failure
```

The current `relvia::core` target is interface-only. The contract check verifies that its header compiles and basic value semantics work; it does not validate database behavior.

## Design

See [architecture](docs/architecture.md) and [roadmap](docs/roadmap.md). SQLite is the proposed first implementation, PostgreSQL the second to validate portability. Neither is implemented.

## Working with Codex

Repository instructions are in `AGENTS.md`. See [setup](docs/codex.md).

## License

License selection is pending. MIT is the proposed default, to be confirmed by the author before publication. No open-source license grant is made by this scaffold.
