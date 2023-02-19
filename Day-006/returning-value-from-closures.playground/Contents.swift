import UIKit

let drivingWithReturn = { (place: String, speed: Int) -> (ret: String, laugh: String) in
    return (ret: "I am driving to \(place) by my car with \(speed) km/h", laugh: "Haha")
}

print(drivingWithReturn("SG", 199).ret)
print(drivingWithReturn("SG", 199).laugh)
