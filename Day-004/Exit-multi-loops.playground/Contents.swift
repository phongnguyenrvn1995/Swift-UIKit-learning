import UIKit

outer: for i in 1...10 {
    for j in 1...10 {
        for k in 1...10 {
            print("i = \(i), j = \(j), k = \(k)")
            if i == 2 && j == 2 && k == 2 {
                break outer
            }
        }
    }
}
