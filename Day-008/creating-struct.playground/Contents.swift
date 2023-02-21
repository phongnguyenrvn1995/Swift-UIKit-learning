import UIKit

struct Sport {
    var name: String
}

let sport1 = Sport(name: "Tennis")
//sport1.name = "" // failed, because let
print(sport1.name)

var sport2 = Sport(name: "Soccer")
sport2.name = "SOCCER"
print(sport2.name)
