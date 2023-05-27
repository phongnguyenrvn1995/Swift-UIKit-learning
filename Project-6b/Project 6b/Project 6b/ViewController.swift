//
//  ViewController.swift
//  Project 6b
//
//  Created by Phong Nguyễn Hoàng on 26/05/2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lb1 = UILabel()
        lb1.translatesAutoresizingMaskIntoConstraints = false
        lb1.backgroundColor = UIColor.red
        lb1.text = "THESE"
        lb1.sizeToFit()
        view.addSubview(lb1)
        
        let lb2 = UILabel()
        lb2.translatesAutoresizingMaskIntoConstraints = false
        lb2.backgroundColor = .cyan
        lb2.text = "ARE"
        lb2.sizeToFit()
        view.addSubview(lb2)
        
        let lb3 = UILabel()
        lb3.translatesAutoresizingMaskIntoConstraints = false
        lb3.backgroundColor = .yellow
        lb3.text = "SOME"
        lb3.sizeToFit()
        view.addSubview(lb3)
        
        let lb4 = UILabel()
        lb4.translatesAutoresizingMaskIntoConstraints = false
        lb4.backgroundColor = .green
        lb4.text = "AWESOME"
        lb4.sizeToFit()
        view.addSubview(lb4)
        
        let lb5 = UILabel()
        lb5.translatesAutoresizingMaskIntoConstraints = false
        lb5.backgroundColor = .orange
        lb5.text = "LABLES"
        lb5.sizeToFit()
        view.addSubview(lb5)
        
        //VFL
        /*let dictionary = [
            "lb1" : lb1,
            "lb2" : lb2,
            "lb3" : lb3,
            "lb4" : lb4,
            "lb5" : lb5
        ]
        
        for (key, _) in dictionary {
            view.addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[\(key)]|",
                options:[],
                metrics: nil,
                views: dictionary))
        }
        
        let metrics = [
            "labelHeight": 88
        ]
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[lb1(labelHeight@999)]-[lb2(lb1)]-[lb3(lb1)]-[lb4(lb1)]-[lb5(lb1)]-(>=10)-|",
            metrics: metrics,
            views: dictionary))*/
        //end VFL
        
        //anchor
        var previousView: UIView?
        for lb in [lb1, lb2, lb3, lb4, lb5] {
//            lb.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            lb.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
            lb.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
            
            lb.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2, constant: -10).isActive = true
            
            if let previousView = previousView {
                lb.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: 10).isActive = true
            } else {
                lb.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
            }
            previousView = lb
        }
        //end anchor
        
    }
}

