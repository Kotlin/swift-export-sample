import SwiftUI
import Shared

struct EnumsView: View {
    var body: some View {
        let direction = startingDirection()

        FeatureScreen(
            title: "Enums",
            summary: "A Kotlin enum class is a native Swift enum. `switch` is exhaustive without `default`, and the Kotlin properties and methods are available on the cases."
        ) {
            DemoRow("startingDirection()", direction)
            DemoRow("switch direction { ... }", arrow(for: direction))
            DemoRow(".NORTH.turnRight()", Direction.NORTH.turnRight())
            DemoRow(".WEST.degrees", Direction.WEST.degrees)
            DemoRow("Direction.allCases", Direction.allCases.map(\.description).joined(separator: ", "))
            DemoRow(".SOUTH.rawValue (ordinal)", Direction.SOUTH.rawValue)
            DemoRow("Direction(rawValue: 1)", Direction(rawValue: 1))
            DemoRow("Direction(\"WEST\")", Direction("WEST"))
        }
    }

    private func arrow(for direction: Direction) -> String {
        switch direction {
        case .NORTH: "↑"
        case .EAST: "→"
        case .SOUTH: "↓"
        case .WEST: "←"
        }
    }
}
