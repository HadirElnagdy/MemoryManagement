# Memory Management in iOS

This repository contains a comprehensive guide and demo on memory management in iOS. It covers memory handling before ARC, the introduction of ARC, and best practices for managing references and closures.

## Table of Contents

1. [Introduction to Memory Management](#introduction-to-memory-management)
2. [Handling Memory in iOS Before ARC](#handling-memory-in-ios-before-arc)
3. [Automatic Reference Counting (ARC)](#automatic-reference-counting-arc)
4. [Strong Reference Cycles](#strong-reference-cycles)
5. [Weak and Unowned References](#weak-and-unowned-references)
6. [Managing Closures](#managing-closures)
7. [Demo: How ARC Works](#demo-how-arc-works)

## Introduction to Memory Management

Memory management is a critical aspect of software development, ensuring efficient use of memory and preventing memory leaks and crashes. In iOS, memory management has evolved significantly over time.

[Read more](#introduction-to-memory-management)

## Handling Memory in iOS Before ARC

Before ARC, iOS developers manually managed memory using Manual Retain-Release (MRR). This involved explicitly retaining and releasing objects to control their lifetimes.

[Read more](#handling-memory-in-ios-before-arc)

## Automatic Reference Counting (ARC)

Automatic Reference Counting (ARC) was introduced to simplify memory management in iOS. ARC automatically manages the retain and release calls, reducing the risk of memory leaks and improving code maintainability.

[Read more](#automatic-reference-counting-arc)

## Strong Reference Cycles

Strong reference cycles, or retain cycles, occur when two or more objects hold strong references to each other, preventing them from being deallocated. This section explains how to identify and resolve strong reference cycles.

[Read more](#strong-reference-cycles)

## Weak and Unowned References

Weak and unowned references help break strong reference cycles. Weak references do not increase the reference count and can be nil, while unowned references assume the referenced object will always be in memory.

[Read more](#weak-and-unowned-references)

## Managing Closures

Closures in Swift can capture references to variables and constants from their surrounding context. Managing these captured references properly is crucial to avoid retain cycles.

[Read more](#managing-closures)

## Demo: How ARC Works

This repository includes a demo that illustrates how ARC works in Swift, including examples of creating and releasing objects, managing strong and weak references, and avoiding retain cycles.

[Read more](#demo-how-arc-works)

---

### Detailed Sections

#### Introduction to Memory Management

Memory management involves allocating and deallocating memory resources to ensure efficient use of memory. Proper memory management prevents issues such as memory leaks and crashes, which can degrade the performance and reliability of an application.

#### Handling Memory in iOS Before ARC

Before ARC, developers used Manual Retain-Release (MRR) for memory management. This required explicit calls to `retain`, `release`, and `autorelease` to manage the lifecycle of objects.

```objc
// Create an object
Person *john = [[Person alloc] init];

// Retain the object (increase retain count)
[john retain];

// Use the object
[john doSomething];

// Release the object (decrease retain count)
[john release];
```

#### Automatic Reference Counting (ARC)

ARC automates memory management by automatically inserting retain and release calls at compile time. This reduces the risk of memory leaks and simplifies the development process.

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

#### Strong Reference Cycles

Strong reference cycles occur when two objects hold strong references to each other, preventing deallocation.

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

#### Weak and Unowned References

Weak references do not increase the reference count and are set to nil when the object is deallocated. Unowned references do not increase the reference count but assume the object will always be in memory.

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

#### Managing Closures

Closures capture references to variables and constants from their surrounding context. To avoid retain cycles, use capture lists with weak or unowned references.

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

