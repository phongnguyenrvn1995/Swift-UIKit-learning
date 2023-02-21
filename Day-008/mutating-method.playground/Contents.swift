import UIKit

struct Person {
    var name: String
    mutating func changeName(newName: String) {
        name = newName
    }
    
    mutating func change() {
        changeName(newName: "Hi")
    }
    
    func sayHi() {
        print("Hi")
    }
}

let person = Person(name: "Java")
//person.changeName(newName: "Swift") // failed
person.sayHi() // OK
