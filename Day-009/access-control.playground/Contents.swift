import UIKit

struct Person {
    private var id: Int
    var name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    private func sayHi() {
        print("hi")
    }
}

var person = Person(id: 1, name: "Swift")
