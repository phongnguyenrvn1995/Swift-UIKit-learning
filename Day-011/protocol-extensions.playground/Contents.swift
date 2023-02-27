import UIKit

let array = ["Java", "Kotlin", "Swift"]
let set = Set(array)


extension Collection {
    func summary() {
        print("There are \(count) of us")
        for item in self {
            print(item)
        }
    }
    
    func sayHi() {
        print("Hello")
    }
}

array.summary()
array.sayHi()
set.summary()
