//
//  Favourite.swift
//  Day 50
//
//  Created by Phong Nguyễn Hoàng on 12/08/2023.
//

import Foundation
class Favourite: NSObject, NSCoding {
    var name: String
    var link: String
    var date: String
    
    init(name: String, link: String, date: String) {
        self.name = name
        self.link = link
        self.date = date
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(link, forKey: "link")
        coder.encode(date, forKey: "date")
    }
    
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as? String ?? ""
        link = coder.decodeObject(forKey: "link") as? String ?? ""
        date = coder.decodeObject(forKey: "date") as? String ?? ""
    }
}
