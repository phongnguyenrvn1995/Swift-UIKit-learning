//
//  ViewController.swift
//  Milestone-Projects-28-30
//
//  Created by Phong Nguyễn Hoàng on 26/01/2024.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var gameTitle: UILabel!
    var aboutAC: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initTitle()
    }
    
    func initTitle() {
        gameTitle.attributedText = "PERFECT PAIRS".colorfulString()
    }

    @IBAction func cardsTapped(_ sender: Any) {
    }
    
    @IBAction func playTapped(_ sender: Any) {
    }
    
    @IBAction func aboutTapped(_ sender: Any) {
        aboutAC = UIAlertController(title: "", message: nil, preferredStyle: .alert)
        aboutAC.view.searchVisualEffectsSubview()?.effect = UIBlurEffect(style: .dark)
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont(name: "Marker Felt", size: 40)
        let attrString = "THIS GAME IS\nMADE BY\nBLUE MOON".colorfulString()
        let alignment = NSMutableParagraphStyle()
        alignment.lineSpacing = 15
        attrString.addAttribute(.paragraphStyle, value: alignment, range: NSRange(0...attrString.length - 1))
        lb.attributedText = attrString
        lb.numberOfLines = 0
        lb.textAlignment = .center
        lb.lineBreakMode = .byWordWrapping
        aboutAC.view.addSubview(lb)
        NSLayoutConstraint.activate([
            aboutAC.view.heightAnchor.constraint(equalToConstant: 250),
            lb.topAnchor.constraint(equalTo: aboutAC.view.topAnchor, constant: 20),
            lb.leadingAnchor.constraint(equalTo: aboutAC.view.leadingAnchor, constant: 20),
            lb.trailingAnchor.constraint(equalTo: aboutAC.view.trailingAnchor, constant: -20),
            lb.bottomAnchor.constraint(equalTo: aboutAC.view.bottomAnchor, constant: -40),
        ])
        
        present(aboutAC, animated: true) { [weak aboutAC, weak self] in
            guard let ac = aboutAC else { return }
            guard let self = self else { return }
            ac.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(outSideTapped)))
        }
    }
    
    @objc func outSideTapped() {
        aboutAC.dismiss(animated: true)
    }
}

extension UIView {
    func searchVisualEffectsSubview() -> UIVisualEffectView? {
        if let visualEffectView = self as? UIVisualEffectView {
            return visualEffectView
        } else {
            for subview in subviews {
                if let found = subview.searchVisualEffectsSubview() {
                    return found
                }
            }
        }
        
        return nil
    }
}
