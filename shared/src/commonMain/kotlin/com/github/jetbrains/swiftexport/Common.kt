class MyClass(val property: Int) {

    class Nested(val nestedProperty: Int)
}

typealias MyNested = MyClass.Nested

fun sum(a: MyClass, b: MyNested): Int =
    a.property + b.nestedProperty