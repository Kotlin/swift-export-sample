import Testing
import Shared

struct SealedAndEnumTests {

    @Test func sealedClassesSupportExhaustiveSwitch() {
        let descriptions = loadingStates().map { state -> String in
            switch state.sealedType() {
            case .loading: "loading"
            case .success(let success): "success: \(success.value.data)"
            case .error(let error): "error: \(error.value.message)"
            }
        }
        #expect(descriptions == ["loading", "success: Kotlin ❤️ Swift", "error: Network is unavailable"])
    }

    @Test func sealedInterfaces() {
        #expect(execute(command: Command.Move(steps: 3)) == "Moving 3 steps")
        #expect(execute(command: Command.Stop.shared) == "Stopped")
    }

    @Test func enumsAreSwiftEnums() {
        let planet = homePlanet()
        #expect(planet == .Earth)
        #expect(Planet.allCases.count == 3)
        #expect(planet.next() == .Jupiter)
        #expect(planet.rawValue == 1)
        #expect(Planet("Mercury") == .Mercury)
        #expect(abs(planet.surfaceGravity - 9.8) < 0.1)
        #expect(Direction.North.opposite == .South)
    }
}
