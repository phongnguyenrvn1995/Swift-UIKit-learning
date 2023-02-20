import UIKit

func travel(action: (String) -> String) {
    print("I am getting ready to go")
    print(action("London"))
    print("I am arrived")
}

//travel(action: {(place: String) -> String in
//    return "I am going to \(place) in my car"
//})
//
//// trailing closures syntax
//travel() { (place: String) -> String in
//    return "I am going to \(place) in my car"
//}
//
//travel { (place: String) -> String in
//    return "I am going to \(place) in my car"
//}

func sum(action: (Int, Int) -> Int) {
    print(action(1, 2))
}

sum(action: +)
sum(action: -)
sum(action: *)
sum(action: /)

sum { a, b in
    return a + b
}
