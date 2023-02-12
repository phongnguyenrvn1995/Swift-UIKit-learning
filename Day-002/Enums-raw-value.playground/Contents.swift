import UIKit

enum Planet: Int {
    case mercury // rawValue = 0
    case venus = 11 // rawValue
    case earth // rawValue = 12
    case mars // rawValue = 13
}

let planet = Planet(rawValue: 10) // nil


enum MusicGenre: String {
    case jazz = "jazz"
    case countrySide
}

let jazz = MusicGenre(rawValue: "jazz") // jazz
let countrySide = MusicGenre(rawValue: "countrySide") // countrySide


enum Test {
    case a
    case b
}

//let a = Test() // no way
