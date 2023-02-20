import UIKit

func travel(action: (String, Int) -> String) {
    print("I am ready to go!")
    print(action("London", 60))
    print("I arrived")
}

travel {
    "I am going to \($0) at \($1) miles per hour."
}
