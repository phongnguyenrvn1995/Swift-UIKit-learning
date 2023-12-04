import UIKit


extension Collection where Element: BinaryInteger {
    func countOddAndEven() -> (odd: Int, even: Int) {
        var odd = 0
        var even = 0
        self.forEach { item in
            if item.isMultiple(of: 2) {
                even += 1
            } else {
                odd += 1
            }
        }
        return (odd: odd, even: even)
    }
}

let a = ["1", "2", "3"]
let b = [1, 2, 3]

b.countOddAndEven()
