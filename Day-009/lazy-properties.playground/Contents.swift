import UIKit

struct FamilyTree {
    init() {
        print("Creating family tree object")
    }
}

struct Person {
    var name: String
    lazy var familyTree: FamilyTree = FamilyTree()
    init(name: String) {
        self.name = name
    }
}

var person = Person(name: "Kotlin")
print(person.name)
print(person.familyTree)
