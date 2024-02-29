import SwiftUI
@testable import Shared

struct ContentView: View {
    @State private var showContent = false
    var body: some View {
        VStack(spacing: 8) {
            Text("foo: \(com.github.jetbrains.swiftexport.foo())")
            Text("bar: \(com.github.jetbrains.swiftexport.bar())")
            Text("foobar with 5: \(com.github.jetbrains.swiftexport.foobar(param: 5))")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
