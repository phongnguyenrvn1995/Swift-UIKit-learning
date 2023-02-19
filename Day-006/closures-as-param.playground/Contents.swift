import UIKit

let driving = {
    print("I am driving my car!")
}

let detail = { (place: String, speed: Int) -> String in
    return "to \(place) with \(speed) km/h"
}

func travel(action: () -> Void, detail: (String, Int) -> String) {
    action()
    print(detail("SaiGon", 199))
}

travel(action: driving, detail: detail)
