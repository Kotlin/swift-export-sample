import SwiftUI
import Shared

/// Swift subclass of an open Kotlin class. `Shared.Shape` is module-qualified,
/// because SwiftUI declares its own `Shape`.
final class SwiftCircle: Shared.Shape {
    let radius: Double

    init(radius: Double) {
        self.radius = radius
        super.init(name: "Circle")
    }

    override func area() -> Double {
        Double.pi * radius * radius
    }
}

/// Swift subclass that overrides an open Kotlin property and method, and calls `super`.
final class LoudFormatter: MessageFormatter {
    override var prefix: String { "Swift" }

    override func format(message: String) -> String {
        super.format(message: message).uppercased()
    }
}

/// A Swift subclass of an abstract Kotlin class. `Shape.area()` is abstract, so it must be
/// overridden; the compiler doesn't enforce this, and a missing override traps at runtime.
final class Triangle: Shared.Shape {
    let base: Double
    let height: Double

    init(base: Double, height: Double) {
        self.base = base
        self.height = height
        super.init(name: "Triangle")
    }

    override func area() -> Double { base * height / 2 }
}

struct ClassesView: View {
    var body: some View {
        let myClass = MyClass(property: 5)
        let stepCounter = StepCounter()
        let step = StepCounter.Step(by: 5, outer__: stepCounter)
        let point = Point(x: 1, y: 2)
        let account = Account(owner: "Ada")

        FeatureScreen(
            title: "Classes",
            summary: "A Kotlin class is a final Swift class with one `init` per constructor; `open` and `abstract` classes are open Swift classes that Swift can subclass. Nested classes stay nested, the Kotlin typealias `MyNested` is a Swift typealias for `MyClass.Nested`, and an inner class takes the outer instance as `outer__`. A data class backs Swift `==`, `Hashable` and `description`, and a value class is a wrapper."
        ) {
            Section("Nested and inner classes") {
                DemoRow("MyClass.Inner(outer__: MyClass(property: 5)).outerProperty()", MyClass.Inner(outer__: myClass).outerProperty())
                DemoRow("sum(a: MyClass(property: 5), b: MyNested(nestedProperty: 6))", sum(a: myClass, b: MyNested(nestedProperty: 6)))
                DemoRow("StepCounter.Step(by: 5, outer__: stepCounter).apply()", step.apply())
                DemoRow("stepCounter.value after apply()", stepCounter.value)
            }
            Section("Open and abstract classes") {
                DemoRow("Rectangle(width: 3, height: 4).area()", Rectangle(width: 3, height: 4).area())
                DemoRow("Square(side: 2).describe() — override that calls super", Square(side: 2).describe())
                DemoRow("Triangle(base: 3, height: 5).describe() — Swift subclass", Triangle(base: 3, height: 5).describe())
                DemoRow("describeAll(shapes: [Rectangle, Square, Triangle, SwiftCircle])", describeAll(shapes: [
                    Rectangle(width: 3, height: 4),
                    Square(side: 2),
                    Triangle(base: 3, height: 5),
                    SwiftCircle(radius: 1),
                ]).joined(separator: "; "))
                DemoRow(#"formatWith(formatter: LoudFormatter(), message: "hello")"#, formatWith(formatter: LoudFormatter(), message: "hello"))
            }
            Section("object and companion object") {
                CounterRow()
                DemoRow("Temperature.Companion.shared.fromCelsius(value: 100).fahrenheit", Temperature.Companion.shared.fromCelsius(value: 100).fahrenheit)
                DemoRow("Temperature.Companion.shared.freezing.celsius", Temperature.Companion.shared.freezing.celsius)
                DemoRow("AppInfo.shared.banner()", AppInfo.shared.banner())
            }
            Section("data class") {
                DemoRow(#"Point(x: 1, y: 2) — description"#, "\(point)")
                DemoRow("point.copy(x: 5, y: point.y)", "\(point.copy(x: 5, y: point.y))")
                DemoRow("point == Point(x: 1, y: 2)", point == Point(x: 1, y: 2))
                DemoRow("Set([point, Point(x: 1, y: 2)]).count — Hashable", Set([point, Point(x: 1, y: 2)]).count)
            }
            Section("value class and lateinit") {
                DemoRow(#"email(value: "kotlin@jetbrains.com").domain"#, email(value: "kotlin@jetbrains.com").domain)
                DemoRow(#"account.nickname = "ada" — lateinit var has a setter"#, accountNickname(account))
            }
        }
    }

    private func accountNickname(_ account: Account) -> String {
        account.nickname = "ada"
        return account.nickname
    }
}

/// Kotlin objects are not observable, so the row keeps its own copy of the counter.
/// It is a separate view, so a tap only updates this row.
private struct CounterRow: View {
    @State private var value = Counter.shared.value

    var body: some View {
        HStack {
            DemoRow("Counter.shared.increment()", value)
            Spacer()
            Button("Run") {
                value = Counter.shared.increment()
            }
        }
    }
}
