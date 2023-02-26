import UIKit

class Singer {
    var name: String
    init(name: String) {
        self.name = name
    }
}

var danTruong = Singer(name: "Dan Truong")
var object = danTruong

danTruong.name = "DAN TRUONG"
print(danTruong.name)
print(object.name)

struct SingerStruct {
    var name: String
}

var phamTruong = SingerStruct(name: "Pham Truong")
var object2 = phamTruong
object2.name = "PHAM TRUONG"
print(phamTruong.name)
print(object2.name)
