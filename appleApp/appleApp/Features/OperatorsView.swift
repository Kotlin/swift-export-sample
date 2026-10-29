import SwiftUI
import Shared

struct OperatorsView: View {
    var body: some View {
        let a = Vector(x: 1, y: 2)
        let b = Vector(x: 3, y: 4)

        FeatureScreen(
            title: "Operators",
            summary: "Kotlin operator functions are Swift operators: `plus`, `minus`, `times` and `unaryMinus` keep their symbols, `compareTo` gives `<`, `<=`, `>` and `>=`, `get`/`set` is a subscript, `contains` is `~=`, `invoke` is `callAsFunction`, and an infix function stays a method."
        ) {
            Section("Arithmetic operators on Vector") {
                DemoRow("Vector(x: 1, y: 2) + Vector(x: 3, y: 4)", components(a + b))
                DemoRow("(a + b) * 2", components((a + b) * 2))
                DemoRow("-a", components(-a))
                DemoRow("(a + b).length()", (a + b).length())
            }
            Section("compareTo gives comparison operators") {
                DemoRow("Vector(x: 1, y: 2) < Vector(x: 3, y: 4)", a < b)
                DemoRow("Vector(x: 1, y: 2) >= Vector(x: 3, y: 4)", a >= b)
            }
            Section("get and set is a subscript") {
                DemoRow("Grid(width: 2, height: 2): grid[2] = 7; grid[2]", gridValue())
                DemoRow("grid ~= 7 — contains", gridContains())
            }
            Section("invoke and infix") {
                DemoRow("Multiplier(factor: 2)(value: 21)", Multiplier(factor: 2)(value: 21))
                DemoRow("2.power(exponent: 10)", Int32(2).power(exponent: 10))
            }
        }
    }

    private func components(_ vector: Vector) -> String {
        "x \(vector.x), y \(vector.y)"
    }

    private func gridValue() -> String {
        let grid = Grid(width: 2, height: 2)
        grid[2] = 7
        return String(grid[2])
    }

    private func gridContains() -> String {
        let grid = Grid(width: 2, height: 2)
        grid[2] = 7
        return String(grid ~= 7)
    }
}
