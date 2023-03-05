import UIKit

var evenNumbers = [2, 4, 6, 8]
var songs = ["Autumn", "Winter"]
type(of: evenNumbers)
type(of: songs)

var songs2: [String] = ["Autumn", "Winter"]
var mix: [Any] = ["Autumn", "Winter", 3, 4]

var defineArray: [String] // define only
defineArray = [] // create

var array2 = [String]() // define & create


var mergeArrays: [Any] = evenNumbers + songs
mergeArrays += ["Spring"]
