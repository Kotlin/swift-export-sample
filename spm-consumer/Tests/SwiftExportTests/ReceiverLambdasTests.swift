import Testing
import Shared

struct ReceiverLambdasTests {

    @Test func receiverIsTheFirstClosureParameter() {
        // ShoppingList.() -> Unit is (ShoppingList) -> Void
        let items = shoppingList { list in
            list.add(item: "milk")
            list.add(item: "bread")
        }
        #expect(items == ["milk", "bread"])
        #expect(breakfast() == ["eggs", "coffee"])
    }

    @Test func otherParametersFollowTheReceiver() {
        // String.(Int) -> String is (String, Int32) -> String
        #expect(numbered(words: ["Kotlin", "Swift"]) { word, number in "\(number). \(word)" } == ["1. Kotlin", "2. Swift"])
        // A returned String.() -> String is (String) -> String
        #expect(surroundWith(marker: "*")("bold") == "*bold*")
    }
}
