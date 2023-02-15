import UIKit

let weather = "sunny"

switch weather {
case "rain":
    print(weather)
    print("Bring an umbrella")
    fallthrough
case "snow":
    print("wrap up warm")
    fallthrough
case "sunny":
    print("Wear sunscreen")
    fallthrough
default:
    print("Enjoy your day")
}


enum Test {
    case a
    case b
    case c
    case d
}

let test = Test.a
switch test {
case Test.a:
    print("A")
case Test.b:
    print("B")
case Test.c:
    print("C")
case Test.d:
    print("D")
}
