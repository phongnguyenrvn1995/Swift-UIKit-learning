import UIKit

let view1 = UIView(frame: CGRect(x: 50, y: 50, width: 128, height: 128))
let view2 = UIView(frame: CGRect(x: 200, y: 200, width: 128, height: 128))

let tap = CGPoint(x: 10, y: 10)
let convertedTo = view1.convert(tap, to: view2)

let convertedFrom = view1.convert(tap, from: view2)
