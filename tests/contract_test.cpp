#include <relvia/database.hpp>
#include <type_traits>

static_assert(std::is_abstract_v<relvia::Driver>);
static_assert(std::is_abstract_v<relvia::Connection>);
static_assert(std::has_virtual_destructor_v<relvia::Statement>);

int main() {
    const auto null = relvia::Value{};
    const auto number = relvia::Value{std::int64_t{42}};
    const auto defaults = relvia::Capabilities{};
    return std::holds_alternative<std::monostate>(null) && std::get<std::int64_t>(number) == 42
        && !defaults.transactions && !defaults.savepoints ? 0 : 1;
}
