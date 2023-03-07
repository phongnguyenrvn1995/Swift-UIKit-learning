import UIKit

struct Person {
    var clothes: String {
        willSet {
            print("willSet newValue = \(newValue)")
        }
        didSet {
            print("didSet oldValue = \(oldValue)")
        }
    }
    
    var shoes: String
    
    var status: String {
        get {
            return "\(clothes) + \(shoes)"
        }
        set {
            self.clothes = newValue
        }
    }
    
    func describe() {
        print("clothes = \(clothes), shoes = \(shoes)")
    }
}

var p = Person(clothes: "Jacket", shoes: "Btit")
p.status
p.status = "Bikini"
