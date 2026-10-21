import XCTest
@testable import Shared
@testable import ModuleA
@testable import ModuleB
@testable import ModuleC

// The full set of language feature tests lives in spm-consumer/Tests and runs with `swift test`.
// These tests check the modules embedded into the app by `embedSwiftExportForXcode`.

final class SharedTests: XCTestCase {

    func testSharedFunction() {
        XCTAssertEqual(sharedFunction(), 15)
    }

    func testIosSpecificApi() {
        XCTAssertEqual(iosBar(), 125)
        XCTAssertTrue(platformName().hasPrefix(UIDevice.current.systemName))
        XCTAssertEqual(currentDevice().model, UIDevice.current.model)
    }

    func testSuspendFunction() async throws {
        let users = try await UsersViewModel().loadUsers()
        XCTAssertEqual(users.map(\.name), ["John Doe", "Jane Doe"])
    }
}

final class ModuleATests: XCTestCase {

    func testModuleAClass() {
        XCTAssertEqual(ClassFromA(name: "A").hello(), "Hello from A")
        XCTAssertEqual(useClassFromA().hello(), "Hello from class_A")
    }

    func testIosSpecificApi() {
        XCTAssertEqual(iosModuleABar(), 54321)
    }
}

final class ModuleBTests: XCTestCase {

    func testModuleBClass() {
        XCTAssertEqual(ClassFromB(name: "B").hello(), "Hello from B")
        XCTAssertEqual(useClassFromB().hello(), "Hello from class_B")
    }

    func testIosSpecificApi() {
        XCTAssertEqual(iosModuleBBar(), 12345)
    }
}

final class ModuleCTests: XCTestCase {

    func testExposedImplementationDependency() {
        XCTAssertEqual(moduleCFunction(), 7)
        let tracker = analytics()
        tracker.track(event: Event(name: "test", properties: [:]))
        XCTAssertEqual(tracker.trackedEvents().map(\.name), ["test"])
    }
}
