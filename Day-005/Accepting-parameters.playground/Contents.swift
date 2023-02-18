import UIKit

func square(num: Int) {
    print(num * num)
//    num *= num // failed, because num is const
}

var i = 8
square(num: i)
print(i)
