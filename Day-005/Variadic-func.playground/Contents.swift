import UIKit

func square(numbers: Int...) {
    for num in numbers {
        print("square of \(num) is \(num * num)")
    }
}

square(numbers: 1, 2, 3)
