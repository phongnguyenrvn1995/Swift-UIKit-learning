import UIKit

var myTuple = (first: "Java", second: "Kotlin", last: "Swift", addition: 1)
myTuple.0 == myTuple.first

myTuple.first = "Javaaaa"
//myTuple.addition = "1" //faileds
myTuple = (first: "Java", second: "Kotlin", addition: 3, last: "Swift") // warning deprecated
//myTuple = (first: "Java", second: "Kotlin", last: "Swift") // failed
//myTuple = (first: "Java", second: "Kotlin", last: "Swift", addition1: 3) // failed
