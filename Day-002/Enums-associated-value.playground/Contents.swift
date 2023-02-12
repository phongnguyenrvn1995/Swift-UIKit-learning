import UIKit

enum Activity {
    case bored
    case running(destination: String)
    case talking(about: String)
    case singing(song: String)
}

let action1 : Activity = Activity.running(destination: "SAI GON")
let action2 : Activity = Activity.bored
let action3 : Activity = Activity.talking(about: "CS")
let action4 : Activity = Activity.singing(song: "No")

