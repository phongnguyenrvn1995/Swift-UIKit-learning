import UIKit

func travel(action: (String) -> Void) {
    print("I'm getting ready to go")
    action("London")
    print("I arrived!!!")
}

travel(action: { (place: String) -> Void in
    print("I am going to \(place) in my car")
})

// trailing closure syntax
travel() { (place: String) -> Void in
    print("I am going to \(place) in my car")
}

travel {(place: String) -> Void in
    print("I am going to \(place) in my car")
}
