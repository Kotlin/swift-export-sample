import SwiftUI
import Shared
import ModuleA
import ModuleB

struct ContentView: View {
    @State private var showContent = false

    var body: some View {
        VStack(spacing: 8) {
            //Different modules
            let moduleA = useClassFromA()
            Text("Module A: \(moduleA.hello())")
            let moduleB = useClassFromB()
            Text("Module B: \(moduleB.hello()) ")

            //Typealias
            let myClass = MyClass(property: 5)
            let nestedClass = MyNested(nestedProperty: 6)
            Text("Type alias class is \(nestedClass.nestedProperty)")

            //Top-level function
            Text("The sum is: \(sum(a: myClass, b: nestedClass))")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding()
    }

    func testSwiftExport(){
        //Extension function
        let _ = repeated("Hello!", times: 3)
        //Extension property
        let _ = getLen("Hello")
        //Overloading functions
        overloaded(x: "hello")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
