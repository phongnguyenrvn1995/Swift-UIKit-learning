import UIKit

for i in (1...10).reversed() {
    print("for - i = \(i)")
    if i < 7 {
        print("break")
        break
    }
}

var num = 0
while num < 10 {
    print("while - num = \(num)")
    if num > 3 {
        print("break")
        break
    }
    num += 1
}

num = 0
repeat {
    print("repeat - num = \(num)")
    if num > 3 {
        print("break")
        break
    }
    num += 1
} while num < 10
