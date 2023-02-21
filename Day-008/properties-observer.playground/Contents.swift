import UIKit

struct Progress {
    var task: String
    var amount: Int {
        willSet {
            print("The amount before change = \(amount)")
        }
        didSet {
            print("The amount after change = \(amount)")
        }
    }
}

var progress = Progress(task: "TASK", amount: 0)
progress.amount = 10
progress.amount = 20
progress.amount = 30

