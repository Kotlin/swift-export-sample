import SwiftUI
import Shared

struct EnumsView: View {
    var body: some View {
        let planet = homePlanet()

        FeatureScreen(
            title: "Enums",
            summary: "A Kotlin enum class is a native Swift enum. `switch` is exhaustive without `default`, and the Kotlin properties and methods are available on the cases. The Kotlin name is the Swift case name, and the ordinal is `rawValue`."
        ) {
            Section("enum class Planet") {
                DemoRow("homePlanet()", planet)
                DemoRow("homePlanet().surfaceGravity", planet.surfaceGravity)
                DemoRow("homePlanet().next()", planet.next())
                DemoRow("Planet.allCases", Planet.allCases.map(\.description).joined(separator: ", "))
            }
            Section("switch is exhaustive") {
                DemoRow("switch homePlanet() { case .Earth: … }", gravityLabel(planet))
            }
            Section("enum class Direction") {
                DemoRow("Direction.North.opposite", Direction.North.opposite)
                DemoRow("Direction.allCases", Direction.allCases.map(\.description).joined(separator: ", "))
                DemoRow("Direction.South.rawValue (ordinal)", Direction.South.rawValue)
                DemoRow("Direction(rawValue: 1)", Direction(rawValue: 1))
                DemoRow(#"Direction("WEST")"#, Direction("WEST"))
            }
        }
    }

    private func gravityLabel(_ planet: Planet) -> String {
        switch planet {
        case .Mercury: "closest to the Sun"
        case .Earth: "home"
        case .Jupiter: "the largest"
        }
    }
}
