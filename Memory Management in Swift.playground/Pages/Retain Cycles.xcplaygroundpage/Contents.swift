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

print("Number of references on a: \(CFGetRetainCount(a))") // 3
print("Number of references on b: \(CFGetRetainCount(b))") // 3


a = nil
b = nil
