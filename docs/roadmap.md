# First milestones

1. Agree license, product scope and language/toolchain baseline.
2. Refine connection/statement lifetimes, error taxonomy and type conversion policy.
3. Implement SQLite driver with parameter binding, NULL/blob roundtrips, transaction rollback and failure tests.
4. Implement PostgreSQL driver against the same behavioral contract; revise portability assumptions.
5. Add install/export package support and an external find_package consumer test.
6. Select the next higher-level feature based on actual use cases: mapping, schema inspection or code generation.

Do not build all backends, ORM, migrations and async support at once.
