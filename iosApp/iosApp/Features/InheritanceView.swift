import SwiftUI
import Shared

/// A Swift subclass of the Kotlin `open class Animal`.
final class Cat: Animal {
    override func sound() -> String { "Meow" }
}

/// A Swift subclass of the Kotlin `abstract class Figure`. It must override `area()`:
/// the compiler doesn't enforce it, and calling a missing override traps at runtime.
final class Triangle: Figure {
    let base: Double
    let height: Double

    init(base: Double, height: Double) {
        self.base = base
        self.height = height
        super.init()
    }

    override func area() -> Double { base * height / 2 }
}

struct InheritanceView: View {
    var body: some View {
        FeatureScreen(
            title: "Inheritance",
            summary: "Open and abstract Kotlin classes are open Swift classes. Swift can subclass them and override open members; Kotlin code calls the Swift override. Abstract members a Swift subclass doesn't override trap at runtime."
        ) {
            Section("Kotlin subclass") {
                DemoRow("Dog(name: \"Rex\").introduce()", Dog(name: "Rex").introduce())
            }
            Section("Swift subclass, dispatched from Kotlin") {
                DemoRow("Cat(name: \"Tom\").introduce()", Cat(name: "Tom").introduce())
                DemoRow("introduceAll(animals: [Dog, Cat])", introduceAll(animals: [Dog(name: "Rex"), Cat(name: "Tom")]).joined(separator: "; "))
            }
            Section("Abstract classes") {
                DemoRow("Square(side: 1.5).describeArea()", Square(side: 1.5).describeArea())
                DemoRow("Triangle(base: 3, height: 5).describeArea() — Swift subclass", Triangle(base: 3, height: 5).describeArea())
            }
        }
    }
}
