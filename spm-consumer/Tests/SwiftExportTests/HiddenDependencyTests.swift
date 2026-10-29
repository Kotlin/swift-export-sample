import Testing
import Shared
import KotlinRuntime
// The hidden Koin dependency is exported as a stub module
import IoInsertKoinKoinCore

struct HiddenDependencyTests {

    @Test func wrapperApiHidesKoin() {
        // AppGraph.greetingService() resolves through Koin on the Kotlin side
        #expect(AppGraph.shared.greetingService().welcome(name: "Swift") == "Welcome, Swift! (resolved by Koin)")
    }

    @Test func koinTypesAreEmptyStubs() {
        // HIDDEN keeps the leaked types visible, but only as empty stub classes.
        // AppGraph.koin and AppGraph.modules() still compile, but calling them traps
        let koin: AnyClass = ExportedKotlinPackages.org.koin.core.Koin.self
        let module: AnyClass = ExportedKotlinPackages.org.koin.core.module.Module.self
        #expect(koin is KotlinRuntime.KotlinBase.Type)
        #expect(module is KotlinRuntime.KotlinBase.Type)
    }
}
