import UIKit

func travel(from: String, action: (String, Int) -> String) {
    print("I am here \(from)")
    print(action("Lodon", 199))
    print("I Arrived")
}

travel(from: "SaiGon", action: { (destination: String, speed: Int) -> String in
    return "I am going to \(destination) with \(speed) kph"
})

travel(from: "SAIGON") { (destination: String, speed: Int) -> String in
    return "I am going to \(destination) with \(speed) kph"
}

travel(from: "S4IG0N") { destination, speed -> String in
    return "I am going to \(destination) with \(speed) khp"
}

travel(from: "SAIGON CAPITAL") { destination, speed in
    return "I am going to \(destination) with \(speed) kph"
}

travel(from: "SAIGON VNCH") { destination, speed in
    "I am going to \(destination) with \(speed) kph"
}

travel(from: "RVN Forever") {
    let i = 10
    "I am going to \($0) with \($1) kph \(i)"
}
