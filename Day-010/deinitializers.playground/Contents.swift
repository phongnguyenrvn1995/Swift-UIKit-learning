import UIKit

class Person {
    var name: String = "Person"
    init() {
        print("\(name) init")
    }
    
    func greeting() {
        print("Hello, I'm \(name)")
    }
    
    deinit {
        print("\(name) is no more")
    }
}

for item in 1...10 {
    var person = Person()
    person.name += "\(item)"
    person.greeting()
}
