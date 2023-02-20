import UIKit

func travel() -> (String) -> Void {
    var counter = 1
    return {
        print("I am going to \($0) \(counter) times")
        counter += 1
    }
}

let travel1 = travel()
travel1("London") // 1 times
travel1("London") // 2 times
travel1("London") // 3 times

travel()("London") // 1 times
travel()("London") // 1 times
travel()("London") // 1 times
