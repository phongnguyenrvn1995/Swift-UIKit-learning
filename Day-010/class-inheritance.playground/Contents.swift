import UIKit

class Dog {
    var name: String
    var breed: String
    init(name: String, breed: String) {
        self.name = name
        self.breed = breed
    }
}

class Poodle: Dog {
    var type: String
    init(name: String) {
        type = "Type"
        super.init(name: name, breed: "Poodle")
    }
}

var poodle = Poodle(name: "KiKi")
