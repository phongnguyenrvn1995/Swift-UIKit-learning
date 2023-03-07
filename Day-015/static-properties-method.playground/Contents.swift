import UIKit

struct TaylorFan {
    static var TOTAL_INSTANCE = 0
    var name: String
    var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
        TaylorFan.TOTAL_INSTANCE += 1
    }
    
    static func squareTotal() {
        TOTAL_INSTANCE *= TOTAL_INSTANCE
    }
}

TaylorFan.TOTAL_INSTANCE
TaylorFan.squareTotal()
