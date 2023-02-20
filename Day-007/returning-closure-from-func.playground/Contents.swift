import UIKit

func travel() -> (String) -> Void {
    return {(place: String) -> Void in
        print("I am going to \(place)")
    }
}

travel()("London")
