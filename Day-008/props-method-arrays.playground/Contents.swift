import UIKit

var array = ["Java"]
array.count // 1
array.append("Swift") // ["Java", "Swift"]
array.firstIndex(of: "Swift") // 1
array.sorted() // ["Java", "Swift"]
array.remove(at: 0) // ["Swift"]
