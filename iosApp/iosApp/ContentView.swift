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
            
            // suspend call
            if suspendCallResult == nil {
                Text("Loading of Users is called")
                    .task {
                        suspendCallResult = try! await vm.loadUsers()
                    }
            } else {
                let userNames = suspendCallResult!.map { it in it.name }
                Text("Loaded Users: \(userNames)")
            }
            
            // flow demo
            Button("Show users") {
                showDetails = true
            }
            .sheet(isPresented: $showDetails) {
                UsersDetailView(vm: vm)
            }
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
                    for try await user in vm.users {
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
