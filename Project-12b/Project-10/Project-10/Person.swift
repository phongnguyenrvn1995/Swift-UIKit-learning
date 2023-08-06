//
//  Person.swift
//  Project-10
//
//  Created by Phong Nguyễn Hoàng on 27/07/2023.
//

import UIKit

class Person: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
