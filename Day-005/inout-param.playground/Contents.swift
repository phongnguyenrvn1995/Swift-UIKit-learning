import UIKit

func doubleInPlace(num: inout Int) {
    num *= 2
}

//doubleInPlace(num: 4) // failed
let a = 6
//doubleInPlace(num: &a) // failed
var b = 8
//doubleInPlace(num: b) // failed
doubleInPlace(num: &b)
print(b)
