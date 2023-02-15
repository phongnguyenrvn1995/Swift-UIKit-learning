import UIKit

let age1 = 17
let age2 = 18

if age1 >= 18 && age2 >= 18 {
    print("Both ages are over 18")
} else if age1 >= 18 || age2 >= 18 {
    print("At least one of them over 18")
} else {
    print("No one is over 18")
}
