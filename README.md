# Memory Management in iOS

This repository contains a comprehensive guide and demo on memory management in iOS. It covers memory handling before ARC, the introduction of ARC, and best practices for managing references and closures.

## Table of Contents

1. [Introduction to Memory Management](#introduction-to-memory-management)
2. [Handling Memory in iOS Before ARC](#handling-memory-in-ios-before-arc)
3. [Automatic Reference Counting (ARC)](#automatic-reference-counting-arc)
4. [Strong Reference Cycles](#strong-reference-cycles)
5. [Weak and Unowned References](#weak-and-unowned-references)
6. [Managing Closures](#managing-closures)
7. [Conclusion](#conclusion)

## Introduction to Memory Management

Memory management is a critical aspect of software development, ensuring efficient use of memory and preventing memory leaks and crashes. In iOS, memory management has evolved significantly over time.


## Handling Memory in iOS Before ARC

Before Automatic Reference Counting (ARC) was introduced in iOS, developers had to manually manage memory using a system called **Manual Retain-Release (MRR)**, also known as **Manual Reference Counting (MRC)**. Here’s an overview of how memory management was handled before ARC:

### Manual Retain-Release (MRR)

In MRR, developers were responsible for explicitly retaining and releasing objects to manage their lifetimes. This required a thorough understanding of when to retain (increase the reference count) and release (decrease the reference count) objects to avoid memory leaks and dangling pointers.

#### Key Concepts:

1. **Retain**: Increase the reference count of an object. This is done when an object is referenced by another object.
2. **Release**: Decrease the reference count of an object. This is done when an object is no longer needed.
3. **Autorelease**: Adds the object to an autorelease pool, which will send a release message to the object at some later point, typically at the end of the current run loop.

#### Methods:

- `retain`: Increases the retain count by 1.
- `release`: Decreases the retain count by 1. When the retain count reaches 0, the object is deallocated.
- `autorelease`: Adds the object to the autorelease pool for deferred release.

#### Memory Management Rules:

1. **Ownership**: If you create an object using methods like `alloc`, `new`, `copy`, or `mutableCopy`, you own the object and are responsible for releasing it.
2. **Retain/Release Balance**: Every `retain` must be balanced with a `release`. Failure to do so results in memory leaks.
3. **Autorelease Pools**: Used to handle temporary objects that should be released later.

#### Example:

Here’s a basic example of MRR in Objective-C:

```objc
// Create an object
Person *john = [[Person alloc] init];

// Retain the object (increase retain count)
[john retain];

// Use the object
[john doSomething];

// Release the object (decrease retain count)
[john release];

// At this point, the retain count should be 1 (assuming no other retains)

// Another object retains john
[john retain];

// Release it again
[john release];

// Release the object to match the initial alloc
[john release]; // This will deallocate the object if the retain count reaches 0
```

### Autorelease Pool

Autorelease pools were used to manage the memory of objects that should be released at a later point. Typically, an autorelease pool is created at the beginning of the main run loop, and all autoreleased objects are sent a `release` message when the pool is drained.

#### Example:

```objc
// Create an autorelease pool
NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

// Create an autoreleased object
Person *john = [[[Person alloc] init] autorelease];

// Use the object
[john doSomething];

// Drain the pool (releases all autoreleased objects)
[pool drain];
```


## Automatic Reference Counting (ARC)

Automatic Reference Counting (ARC) was introduced to model the lifetime of objects and their relationships. ARC automatically manages the retain and release calls, reducing the risk of memory leaks and improving code maintainability.

```swift
class Person {
    var name: String

    init(name: String) {
        self.name = name
    }

    deinit {
        print("\(name) is being deinitialized")
    }
}

var john: Person? = Person(name: "John Doe")
john = nil // ARC automatically manages the memory
```

## Strong Reference Cycles

One common issue with ARC is the potential for strong reference cycles, also known as retain cycles. This occurs when two or more objects hold strong references to each other, preventing them from being deallocated even when they are no longer needed. To avoid retain cycles, you can use weak or unowned references.

```swift
class Person {
    var name: String
    var apartment: Apartment?

    init(name: String) {
        self.name = name
    }

    deinit {
        print("\(name) is being deinitialized")
    }
}

class Apartment {
    var tenant: Person?

    deinit {
        print("Apartment is being deinitialized")
    }
}

var john: Person? = Person(name: "John Doe")
var unit: Apartment? = Apartment()

john?.apartment = unit
unit?.tenant = john

john = nil
unit = nil
// Strong reference cycle prevents deallocation
```

## Weak and Unowned References

### Weak References: 
A weak reference doesn't keep a strong hold on the referenced object. If the referenced object is deallocated, the weak reference automatically becomes nil.

```swift
class Person {
    var name: String
    weak var apartment: Apartment? // Weak reference

    init(name: String) {
        self.name = name
    }

    deinit {
        print("\(name) is being deinitialized")
    }
}

class Apartment {
    var tenant: Person?

    deinit {
        print("Apartment is being deinitialized")
    }
}

var john: Person? = Person(name: "John Doe")
var unit: Apartment? = Apartment()

john?.apartment = unit
unit?.tenant = john

john = nil
unit = nil
// No strong reference cycle; objects are deallocated
```

### Unowned References: 
An unowned reference is similar to a weak reference but assumes that the referenced object will never be nil during its lifetime. If you try to access an unowned reference after the referenced object has been deallocated, it will result in a runtime error.

```swift
//Use an unowned reference only when you are sure that the reference always refers to an instance that hasn’t been deallocated.

class Customer {
    let name: String
    var card: CreditCard?
    init(name: String) {
        self.name = name
    }
    deinit { print("\(name) is being deinitialized") }
}

//there's no card without a customer
class CreditCard {
    let number: UInt64
    unowned let customer: Customer //because the customer will outlive the card and the card will always have a customer
    init(number: UInt64, customer: Customer) {
        self.number = number
        self.customer = customer
    }
    deinit { print("Card #\(number) is being deinitialized") }
}

var hadir: Customer?
hadir = Customer(name: "Hadir Elnagdy")
hadir!.card = CreditCard(number: 1234_5678_9012_3456, customer: hadir!)
hadir = nil
```

## Managing Closures

Closures capture references to variables and constants from the surrounding context. If a closure captures a strong reference to an object and that object holds a strong reference to the closure, it can create a retain cycle. To prevent this, use capture lists with weak or unowned references when necessary.

```swift
class ViewController {
    var name = "ViewController"

    lazy var printName: () -> Void = { [weak self] in
        guard let self = self else { return }
        print(self.name)
    }

    deinit {
        print("\(name) is being deinitialized")
    }
}

var vc: ViewController? = ViewController()
vc?.printName()
vc = nil
// No retain cycle; ViewController is deallocated
```


## Conclusion

Automatic Reference Counting (ARC) has significantly simplified memory management in iOS, allowing developers to focus more on building features rather than managing memory manually. ARC automatically tracks and manages the reference counts of strong references to objects. It's important to note that ARC only counts strong references and does not manage value types such as structs and enums, which are automatically managed by Swift. By understanding and utilizing ARC, along with weak and unowned references to prevent strong reference cycles, developers can write efficient and memory-safe iOS applications.








