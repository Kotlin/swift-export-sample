import Testing
import Shared

struct GenericWrappersTests {

    @Test func genericStatePayloadsAreErased() async throws {
        var states: [ScreenState] = []
        for try await state in ProfileLoader().load(succeed: true).asAsyncSequence() {
            states.append(state)
        }
        #expect(states.count == 2)
        guard case .ready(let ready) = states[1].sealedType() else {
            Issue.record("expected Ready with a Profile payload")
            return
        }
        // Ready<T>.data is (any _KotlinBridgeable)?, so Swift casts it back
        let profile = ready.value.data as? Profile
        #expect(profile?.name == "Kodee")
        #expect(profile?.followers == 2025)
    }

    @Test func wrapperPayloadsAreTyped() async throws {
        let model = ProfileScreenModel(loader: ProfileLoader())

        var states: [ProfileState] = []
        for try await state in model.load(succeed: false).asAsyncSequence() {
            states.append(state)
        }
        #expect(states.count == 2)
        guard case .error(let error) = states[1].sealedType() else {
            Issue.record("expected Error")
            return
        }
        #expect(error.value.message == "No connection")
        // Ready carries a typed Profile, and headline(state:) is exported
        // because ProfileState is not generic
        #expect(model.headline(state: states[0]) == "Loading…")
        #expect(model.headline(state: states[1]) == "No connection")
    }
}
