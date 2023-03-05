import UIKit

var liveAlbums = 12
switch liveAlbums {
case 0:
    print("0")
case 1:
    print("1")
case 2:
    print("2")
case 10...20:
    print("10 -> 20")
    fallthrough
default:
    print("other")
}

