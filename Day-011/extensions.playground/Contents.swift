import UIKit

extension Int {
    var isEven: Bool {
        return self % 2 == 0
    }
    
    func squared() -> Int {
        return self * self
    }
}

5.squared()
