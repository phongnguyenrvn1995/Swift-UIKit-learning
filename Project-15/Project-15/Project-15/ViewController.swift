//
//  ViewController.swift
//  Project-15
//
//  Created by Phong Nguyễn Hoàng on 10/09/2023.
//

import UIKit

class ViewController: UIViewController {
    var imageVIew: UIImageView!
    var currentAnimation = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        imageVIew = UIImageView(image: UIImage(named: "penguin"))
        imageVIew.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageVIew)
        imageVIew.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        imageVIew.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 384).isActive = true
    }

    @IBAction func tapped(_ sender: UIButton) {
        sender.isHidden = true
        
//        UIView.animate(withDuration: 1, delay: 0, options: [], animations: { [weak self] in
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, animations: {[weak self] in
            switch(self?.currentAnimation) {
            case 0:
                self?.imageVIew.transform = CGAffineTransform(scaleX: 2, y: 2)
                break
            case 1, 3, 5:
                self?.imageVIew.transform = .identity
                break
            case 2:
                self?.imageVIew.transform = CGAffineTransform(translationX: -256, y: -256)
                break
            case 4:
                self?.imageVIew.transform = CGAffineTransform(rotationAngle: .pi * 3 / 2)
                break
            case 6:
                self?.imageVIew.alpha = 0.25
                self?.imageVIew.backgroundColor = .green
                break
            case 7:
                self?.imageVIew.alpha = 1
                self?.imageVIew.backgroundColor = .clear
                break
            default:
                break
            }
        }) { finished in
            sender.isHidden = false
        }
        
        
        currentAnimation += 1
        if currentAnimation > 7 {
            currentAnimation = 0
        }
    }
}

