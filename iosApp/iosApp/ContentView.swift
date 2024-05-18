import SwiftUI
@testable import Shared


struct ContentView: View {
    @State private var showContent = false
    var body: some View {
        VStack(spacing: 8) {
            let myClass = MyClass(property: 5)
            let nestedClass = MyNested(nestedProperty: 6)
            Text("The sum is: \(sum(a: myClass, b: nestedClass))")
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
