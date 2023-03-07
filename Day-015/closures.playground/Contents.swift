import UIKit

var closure1 : () -> String
var closure2 : () -> String

func cl() -> () -> String {
    var i = 1
    return {
        print("\(i)")
        i += 1
        return ""
    }
}

closure1 = cl()
closure1()
closure1()

closure2 = closure1
closure2()
closure2()

closure1()
closure1()
