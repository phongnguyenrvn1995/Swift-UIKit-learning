import UIKit

struct Person {
    var id: String
    init?(id: String) {
        if id.count >= 4 {
            self.id = id
        } else {
            return nil
        }
    }
}

let p1 = Person(id: "J") // nil
let p2 = Person(id: "Java") // OK
