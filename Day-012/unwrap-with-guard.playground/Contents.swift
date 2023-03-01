import UIKit


func greeting(_ name: String?) -> Int {
    print("GO")
    guard let name = name else {
        return 0
    }
    print(name)
    return 1
}

greeting("Swift")
