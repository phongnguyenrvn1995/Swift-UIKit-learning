//
//  ScriptUtils.swift
//  Extension
//
//  Created by Phong Nguyễn Hoàng on 27/10/2023.
//

import UIKit

class ScriptUtils: NSObject {
    static func append(script: Script) {
        let scriptArr = loadListScripts() + [Script(name: script.name!, script: script.script!)]
        let userDefaults = UserDefaults.standard
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: scriptArr, requiringSecureCoding: false) {
            userDefaults.setValue(data, forKey: "list_scripts")
        }
    }
    
    static func loadListScripts() -> [Script] {
        let userDefaults = UserDefaults.standard
        if let data = userDefaults.data(forKey: "list_scripts") {
            if let arr = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Script] {
                return arr
            }
        }
        return []
    }
    
    static func save(scripts: [Script]) {
        let userDefaults = UserDefaults.standard
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: scripts, requiringSecureCoding: false) {
            userDefaults.setValue(data, forKey: "list_scripts")
        }
    }
}
