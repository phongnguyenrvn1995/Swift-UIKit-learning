import UIKit

class Animal {}
class Fish: Animal {}
class Dog: Animal {
    func makeNoise() {
        print("Woof")
    }
}

let animal: Animal = Dog()
let dog = animal as? Dog // dog: Dog?

if let dog = dog {
    dog.makeNoise()
}
