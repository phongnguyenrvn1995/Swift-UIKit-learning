import UIKit

protocol Payable {
    func calculateWages() -> Int
}

protocol NeedTraining {
    func study() -> Void
}

protocol HasVacation {
    func takeVacation(days: Int)
}

protocol Summary: Payable, NeedTraining, HasVacation {}

