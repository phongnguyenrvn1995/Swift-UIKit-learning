import UIKit

//dictionaries
var vMap1 = [String: String]()
vMap1["key"] = "value"

let lMap2 = [String: String]()
//lMap2["key"] = "value" // failed because of let keyword

var dMap3 = Dictionary<String, String>()
dMap3["key"] = "value"

//arrays
var vArr1 = [String]()
vArr1.append("Java")
vArr1[0] = "Kotlin"

let lArr2 = [String]()
//lArr2.append("Java") // failed

var vArr3 = Array<String>()

//sets
var vSet1 = Set<String>()
vSet1.insert("Java")

let lSet2 = Set<String>()
//lSet2.insert("Java") // failed
