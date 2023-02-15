import UIKit

let score = 85
switch score {
case 0..<50:
    print("You failed badly")
case 50...85:
    print("You did OK")
default:
    print("you did greate!")
}

let names = ["Java", "Kotlin", "Swift", "JS"]
print(names[0...2]) // ["Java", "Kotlin", "Swift"]
print(names[1...]) // ["Kotlin", "Swift", "JS"]
