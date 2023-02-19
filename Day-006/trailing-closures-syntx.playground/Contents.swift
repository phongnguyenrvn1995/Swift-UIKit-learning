import UIKit

let driving = {
    print("By my car!!!")
}

func travel(action: () -> Void) {
    print("I am travelling...")
    action()
    print("Arrive!!!")
}

travel(action: driving)
travel() {
    driving()
}
travel {
    driving()
}
