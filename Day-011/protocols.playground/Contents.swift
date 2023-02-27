import UIKit

protocol Identifiable {
    var id : String { get set }
}

struct User: Identifiable {
    var id: String
}

func displayID(thing: Identifiable) {
    print(thing.id)
}

displayID(thing: User(id: "Swift"))
