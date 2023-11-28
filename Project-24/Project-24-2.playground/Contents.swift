//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        let string = "This is a test string"
        let myMutableAttributedString = NSMutableAttributedString(string: string)
        myMutableAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 10), range: NSRange(location: 0, length: 4))
        myMutableAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 20), range: NSRange(location: 5, length: 2))
        myMutableAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 30), range: NSRange(location: 8, length: 1))
        myMutableAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 10, length: 4))
        myMutableAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 50), range: NSRange(location: 15, length: 6))
        
        myMutableAttributedString.addAttribute(.underlineStyle, value: 1, range: NSRange(location: 0, length: 21))
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
