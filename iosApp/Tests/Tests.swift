//
//  swift_export_sampleTests.swift
//  swift-export-sampleTests
//
//  Created by Andrey.Yastrebov on 29.02.24.
//  Copyright © 2024 orgName. All rights reserved.
//

import XCTest
@testable import Shared
@testable import ModuleA
@testable import ModuleB

final class SharedTests: XCTestCase {

    func testSharedFunction() {
        let result = sharedFunction()
        XCTAssertEqual(result, 15, "sharedFunction() should return the expected result")
    }

    func testClassFromA() {
        let result = useClassFromA()
        XCTAssertEqual(result.hello(), "Hello from class_A", "useClassFromA() should return the expected result")
    }

    func testClassFromB() {
        let result = useClassFromB()
        XCTAssertEqual(result.hello(), "Hello from class_B", "useClassFromB() should return the expected result for the given parameter")
    }

    func testBar() {
        let result = iosBar()
        XCTAssertEqual(result, 125, "iosBar() should return the expected result for the given parameter")
    }
}

final class ModuleATests: XCTestCase {

    func testModuleAClass() {
        let instance = ClassFromA(name: "A")
        XCTAssertEqual(instance.hello(), "Hello from A", "hello() should return the expected result")
    }

    func testBar() {
        let result = iosModuleABar()
        XCTAssertEqual(result, 54321, "iosModuleABar() should return the expected result for the given parameter")
    }
}

final class ModuleBTests: XCTestCase {

    func testModuleBClass() {
        let instance = ClassFromB(name: "B")
        XCTAssertEqual(instance.hello(), "Hello from B", "hello() should return the expected result")
    }

    func testBar() {
        let result = iosModuleBBar()
        XCTAssertEqual(result, 12345, "iosModuleBBar() should return the expected result for the given parameter")
    }
}
