//
//  Script.swift
//  Extension
//
//  Created by Phong Nguyễn Hoàng on 25/10/2023.
//

import UIKit

class Script: NSObject, NSCoding {
    var name: String?
    var script: String?
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(script, forKey: "script")
    }
    
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as? String
        script = coder.decodeObject(forKey: "script") as? String
    }
    
    init(name: String, script: String) {
        self.name = name
        self.script = script
    }
    
    override var description: String {
        "name = \(String(describing: name)) script = \(String(describing: script))"
    }
}
