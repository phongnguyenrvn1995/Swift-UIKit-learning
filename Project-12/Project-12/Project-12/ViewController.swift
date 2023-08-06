//
//  ViewController.swift
//  Project-12
//
//  Created by Phong Nguyễn Hoàng on 02/08/2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        defaults.set(25, forKey: "Age")
        defaults.set(true, forKey: "UseFaceID")
        defaults.set(CGFloat.pi, forKey: "Pi")
        
        defaults.set("Phong", forKey: "Name")
        defaults.set(Date(), forKey: "LastRun")
        
        let array = ["Hello", "World"]
        defaults.set(array, forKey: "SaveArray")
        
        let dict = ["Name": "Phong", "Country": "RVN"]
        defaults.set(dict, forKey: "SaveDictionary")
        
        let savedInteger = defaults.integer(forKey: "Age")
        let savedBoolean = defaults.bool(forKey: "UseFaceID")
        
        let savedArray = defaults.object(forKey: "SaveArray") as? [String] ?? [String]()
        let savedDictionary = defaults.object(forKey: "SaveDictionary") as? [String: String] ?? [String: String]()
    }


}

