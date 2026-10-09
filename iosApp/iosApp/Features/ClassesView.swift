import SwiftUI
import Shared

struct ClassesView: View {
    var body: some View {
        let rectangle = Rectangle(width: 3, height: 4)
        let corner = Corner(x: 1, y: 2)
        let fromCorners = rectangleFrom(origin: corner, opposite: Rectangle.Corner(x: 6, y: 8))
        let counter = Counter()
        let step = Counter.Step(by: 5, outer__: counter)

        FeatureScreen(
            title: "Classes",
            summary: "A Kotlin class is a final Swift class with an init per constructor. Nested classes stay nested, and the Kotlin typealias `Corner` is a Swift typealias for `Rectangle.Corner`."
        ) {
            Section("Classes, nested classes, typealiases") {
                DemoRow("Rectangle(width: 3, height: 4).area()", rectangle.area())
                DemoRow("Corner(x: 1, y: 2).y", corner.y)
                DemoRow("rectangleFrom(origin:opposite:).width", fromCorners.width)
            }
            Section("Inner classes take the outer instance") {
                DemoRow("Counter.Step(by: 5, outer__: counter).apply()", step.apply())
                DemoRow("counter.value (private set → read-only)", counter.value)
            }
            Section("object and companion object") {
                DemoRow("AppInfo.shared.banner()", AppInfo.shared.banner())
                DemoRow("Temperature.Companion.shared.freezing.celsius", Temperature.Companion.shared.freezing.celsius)
                DemoRow("…fromFahrenheit(fahrenheit: 212).celsius", Temperature.Companion.shared.fromFahrenheit(fahrenheit: 212).celsius)
            }
        }
    }
}
