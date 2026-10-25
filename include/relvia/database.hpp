#pragma once

#include <cstddef>
#include <cstdint>
#include <memory>
#include <optional>
#include <string>
#include <variant>
#include <vector>

namespace relvia {

using Blob = std::vector<std::byte>;
// This provisional value set is intentionally incomplete: decimal, temporal
// and backend-specific types require a separate design decision.
using Value = std::variant<std::monostate, bool, std::int64_t, double, std::string, Blob>;
using Row = std::vector<Value>;

struct Capabilities {
    bool transactions = false;
    bool savepoints = false;
};

// Statements own their result cursor. One connection is confined to one thread.
// Drivers report operational failures with exceptions (error taxonomy is TBD).
class Statement {
public:
    virtual ~Statement() = default;
    virtual void bind(std::size_t index, const Value& value) = 0; // Zero-based, copied by driver.
    virtual void execute() = 0; // Execute once; cursor initially precedes first row.
    virtual auto next() -> std::optional<Row> = 0; // nullopt means end of results.
};

class Connection {
public:
    virtual ~Connection() = default;
    virtual auto capabilities() const -> Capabilities = 0;
    // Native backend SQL for now; portable SQL generation is a separate layer.
    // Connection must outlive statements; driver must validate this in implementation.
    virtual auto prepare(const std::string& sql) -> std::unique_ptr<Statement> = 0;
    virtual void begin() = 0;
    virtual void commit() = 0;
    virtual void rollback() = 0;
};

class Driver {
public:
    virtual ~Driver() = default;
    // Options are backend-specific; do not log credentials.
    virtual auto connect(const std::string& options) -> std::unique_ptr<Connection> = 0;
};

} // namespace relvia
