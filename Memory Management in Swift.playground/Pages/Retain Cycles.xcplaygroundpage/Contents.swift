//: [Previous](@previous)

import Foundation

class ObjectA {
    var objectB: ObjectB?
    
    deinit {
        print("ObjectA deinitialized")
    }
}

class ObjectB {
    var objectA: ObjectA?
    
    deinit {
        print("ObjectB deinitialized")
    }
}

var a: ObjectA? = ObjectA()
var b: ObjectB? = ObjectB()

a?.objectB = b
b?.objectA = a

a = nil
b = nil
