import Testing
import Shared
import ModuleA
import ModuleB
import ModuleC

struct ModulesTests {

    @Test func libraryConfiguredModule() {
        // :module-a sets its own `moduleName` and `rootPackage`
        #expect(ClassFromA(name: "A").hello() == "Hello from A")
        #expect(moduleAFunction() == 5)
        #expect(useClassFromA().hello() == "Hello from class_A")
    }

    @Test func consumerConfiguredModule() {
        // :module-b is configured by :shared
        #expect(ClassFromB(name: "B").hello() == "Hello from B")
        #expect(moduleBFunction() == 10)
    }

    @Test func exposedImplementationDependency() {
        // :module-c is an implementation dependency with SwiftExportVisibility.EXPOSED
        #expect(moduleCFunction() == 7)
        let tracker = analytics()
        tracker.track(event: Event(name: "test", properties: ["key": "value"]))
        #expect(tracker.trackedEvents().map(\.name) == ["test"])
    }

    @Test func hiddenDependency() {
        // :module-d is HIDDEN: Engine is an empty stub, but Car can still inherit from it
        let car = Car()
        #expect(car.drive() == "Engine started, driving")
        let engine: ExportedKotlinPackages.com.github.jetbrains.moduled.Engine = car
        #expect(engine === car)
    }

    @Test func platformSpecificApi() {
        #expect(platformName().hasPrefix("macOS"))
    }
}
