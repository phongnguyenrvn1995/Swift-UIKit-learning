//
//  ViewController.swift
//  Challenge
//
//  Created by Phong Nguyễn Hoàng on 04/12/2023.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onTapped(_ sender: Any) {
        label.bounceOut(duration: 1)
        10.time {
            print("HAHA\n")
        }
        
        var array = ["P", "H", "O", "O", "N", "G"]
        array.remove(item: "O")
        print(array)
    }
}

extension UIView {
    func bounceOut(duration: TimeInterval) {
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        })
    }
}

extension Int {
    func time(_ closure: () -> Void) {
        if self < 0 { return }
        for _ in 0..<self {
            closure()
        }
    }
}

extension Array where Element: Comparable {
    mutating func remove(item: Element) {
        guard let object = self.firstIndex(of: item) else { return }
        self.remove(at: object)
    }
}
