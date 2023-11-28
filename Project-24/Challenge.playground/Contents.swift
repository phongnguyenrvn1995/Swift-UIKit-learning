//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        let myString = "This\nis\nmy\nSTRING"
        myString.withPrefix("OMG ")
        myString.lines
        "123.0".isNumeric
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()


extension String {
    func withPrefix(_ prefix: String) -> String {
        if self.hasPrefix(prefix) {
            return self
        }
        return "\(prefix)\(self)"
    }
    
    var isNumeric: Bool {
        return Double(self) != nil
    }
    
    var lines: [String] {
        return components(separatedBy: "\n")
    }
}
