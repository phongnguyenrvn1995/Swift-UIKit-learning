import UIKit

func greet(_ person: String, nicely: Bool = true) {
    if nicely {
        print("Hello \(person)")
    } else {
        print("Ohm no, it's \(person) again")
    }
}

greet("Swift")
greet("Swift", nicely: false)
