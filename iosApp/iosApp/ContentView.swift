import SwiftUI

import Shared
import ModuleA
import ModuleB

import CryptoKit

struct ContentView: View {
    @State private var showContent = false
    @State private var suspendCallResult: [User]? = nil
    @State private var showDetails = false
    
    private let vm: UsersViewModel = UsersViewModel()
    
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
            
            // Provide an access to swift-only platform library
            let platform: Platform = .init(md5hasher: { input in
                guard let data = input.data(using: .utf8) else { return "failed" }
                return Insecure.MD5.hash(data: data).description
            })
            Text("Demonstration of \"swift-only library\" usage from kotlin: \(reverseImportExample(platform: platform))")
            
            let provider = IosCryptoProvider()
            Text("Demonstration of \"swift-only library\" usage from kotlin - inheritance: \(processHash(provider: provider, input: "Hello, world!"))")
            
            // suspend call
            if suspendCallResult == nil {
                Text("Loading of Users is called")
                    .task {
                        suspendCallResult = try! await vm.loadUsers()
                    }
            } else {
                let userNames = suspendCallResult!.map { it in it.name }
                Text("Loaded Users: \(userNames.joined(separator: ", "))")
            }
            
            // flow demo
            Button("Show users") {
                showDetails = true
            }
            .sheet(isPresented: $showDetails) {
                UsersDetailView(vm: vm)
            }
            
            // type system improvements
            Text("String now can be consumed as Any: \(TypeSystemImprovements.shared.checkType(input: "str"))")
            Text("Arrays now can be consumed as Any: \(TypeSystemImprovements.shared.checkType(input: [1,2,3]))")
            
            // enum demo
            let e = enumDemonstration()
            switch e {
            case .FirstCase: Text("EnumDemo received first case with property: \(e.i)")
            case .SecondCase: Text("EnumDemo received second case with property: \(e.i)")
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding()
        .task {
            demoSuspendableClosure()
        }
    }

    func testSwiftExport(){
        //Extension function
        let _ = repeated("Hello!", times: 3)
        //Extension property
        let _ = getLen("Hello")
        //Overloading functions
        overloaded(x: "hello")
    }
    
    func demoSuspendableClosure() {
        // suspend functional type demo
        // this scope has no async context - we cannot await
        // try! await vm.loadUsers() // <--- error
        vm.runSuspendBlock {
            // here we have async context - and we can await
            print("hello from suspendable closure - here we can await \(try! await vm.loadUsers())")
        }
    }
}

struct UsersDetailView: View {
    var vm: UsersViewModel
    @State private var items: [User] = []

    var body: some View {
        NavigationStack {
            List(items) { user in
                Text(user.name + " aged: \(user.age)")
            }
            .navigationTitle("Users")
            .task {
                items.removeAll()

                do {
                    // usage of typed flows
                    // Attention - no force cast needed, user variable is already typed as User
                    for try await user in vm.users.asAsyncSequence() {
                        items.append(user)
                    }
                } catch {
                    print("flow was cancelled?")
                }
            }
        }
    }
}

extension Shared.User: @retroactive Identifiable { }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

final class IosCryptoProvider: SwiftBase, CryptoProvider {
   func hashMD5(input: String) -> String {
       guard let data = input.data(using: .utf8) else { return "failed" }
       return Insecure.MD5.hash(data: data).description
   }
}
