import UIKit

func username(for id: Int) -> String? {
    if id == 1 {
        return "Tayor swift"
    } else {
        return nil
    }
}

let user = username(for: 15) ?? "Anonymous"
