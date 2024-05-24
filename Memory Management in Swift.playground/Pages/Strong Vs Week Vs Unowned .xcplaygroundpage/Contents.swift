import Cocoa
//MARK: - Weak
//weak should be optional and var because it could change to nil in runtime
class Person {
    let name: String
    init(name: String) { self.name = name }
    var apartment: Apartment?
    deinit { print("\(name) is being deinitialized") }
}


class Apartment {
    let unit: String
    init(unit: String) { self.unit = unit }
    weak var tenant: Person?
    deinit { print("Apartment \(unit) is being deinitialized") }
}

var john: Person?
var unit4A: Apartment?


john = Person(name: "John Appleseed")
unit4A = Apartment(unit: "4A")


john!.apartment = unit4A
unit4A!.tenant = john

john = nil


//MARK: - Unowned
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


