import Shared
import ModuleA
import ModuleB
import ModuleC

// Kotlin code, consumed from a Swift package as regular Swift modules
print("Running on \(platformName())")
print(useClassFromA().hello())
print(useClassFromB().hello())

let tracker = analytics()
tracker.track(event: Event(name: "launch", properties: [:]))
print("Tracked events: \(tracker.trackedEvents().map(\.name))")

print("Fibonacci: \(fibonacci(count: 10))")
print("Total area: \(totalArea(shapes: [Square(side: 2), Rectangle(width: 2, height: 3)]))")

for state in loadingStates() {
    switch state.sealedType() {
    case .loading: print("Loading…")
    case .success(let success): print("Success: \(success.value.data)")
    case .error(let error): print("Error: \(error.value.message)")
    }
}

let users = try await UsersViewModel().loadUsers()
print("Loaded users: \(users.map(\.name).joined(separator: ", "))")
