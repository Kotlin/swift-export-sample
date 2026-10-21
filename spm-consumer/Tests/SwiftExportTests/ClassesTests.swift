import Testing
import Shared

// Swift subclass of an exported open Kotlin class
final class Circle: Shape {
    let radius: Double

    init(radius: Double) {
        self.radius = radius
        super.init(name: "Circle")
    }

    override func area() -> Double {
        Double.pi * radius * radius
    }
}

struct ClassesTests {

    @Test func constructorsNestedAndInnerClasses() {
        let myClass = MyClass(property: 5)
        #expect(MyClass(text: "four").property == 4)
        #expect(sum(a: myClass, b: MyNested(nestedProperty: 6)) == 11)
        #expect(MyClass.Inner(outer__: myClass).outerProperty() == 5)
    }

    @Test func inheritance() {
        let square = Square(side: 2)
        #expect(square.area() == 4)
        #expect(square.describe() == "Square: Rectangle with area 4.0")
        #expect(square is Rectangle)
    }

    @Test func swiftSubclassIsCalledFromKotlin() {
        let shapes: [Shape] = [Circle(radius: 1), Rectangle(width: 2, height: 3)]
        #expect(abs(totalArea(shapes: shapes) - (Double.pi + 6)) < 0.0001)
        #expect(describeAll(shapes: shapes).first!.hasPrefix("Circle with area 3.14"))
    }

    @Test func objectsAndCompanions() {
        let start = Counter.shared.value
        #expect(Counter.shared.increment() == start + 1)
        #expect(Counter.shared === Counter.shared)

        let boiling = Temperature.Companion.shared.fromCelsius(value: 100)
        #expect(boiling.fahrenheit == 212)
    }

    @Test func dataClasses() {
        let point = Point(x: 1, y: 2)
        let moved = point.copy(x: 4, y: 6)
        #expect(moved.x == 4)
        // equals, hashCode and toString are available as ==, hashValue and description
        #expect(point == Point(x: 1, y: 2))
        #expect(point.hashValue == Point(x: 1, y: 2).hashValue)
        #expect(point.description == "Point(x=1, y=2)")
        #expect(point.distanceTo(other: moved) == 5)
    }

    @Test func valueClasses() {
        #expect(email(value: "user@example.com").domain == "example.com")
    }

    @Test func propertyVisibility() {
        let account = Account(owner: "Jane")
        account.deposit(amount: 100)
        #expect(account.balance == 100)
        account.nickname = "JD"
        #expect(account.nickname == "JD")
        #expect(account.formattedBalance == "Jane: 100")
    }

    @Test func renamedDeclarations() {
        // @ObjCName(swiftName = ...) renames the class, the function and the parameter label
        #expect(SwiftFriendlyName().run(21) == 42)
    }
}
