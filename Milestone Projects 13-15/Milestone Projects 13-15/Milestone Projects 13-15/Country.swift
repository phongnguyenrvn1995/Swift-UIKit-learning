//
//  Country.swift
//  Milestone Projects 13-15
//
//  Created by Phong Nguyễn Hoàng on 20/09/2023.
//

import UIKit

class Country: NSObject, Codable {
    var name: String?
    var capital: String?
    var population: Int?
    var area_sq_km: Int?
    var languages: [String] = []
    var currency: String?
    var flag_url: String?
    var major_cities: [String] = []
    var interesting_facts: [String] = []
    
    public override var description: String {
        
        var languages = ""
        self.languages.forEach({ item in
            languages += "\(item), "
        })
        if(!languages.isEmpty) {
            languages = "\(languages.prefix(languages.count - 2))"
        }
        
        var cities = ""
        major_cities.forEach { item in
            cities += "\(item),"
        }
        if(!cities.isEmpty) {
            cities = "\(cities.prefix(cities.count - 2))"
        }
        
        var interests = ""
        interesting_facts.forEach { item in
            interests += """
                         
                            + \(item)
                         """
        }
        
        
        return """
        \(name ?? "")
        - Capital: \(capital ?? "")
        - Population: \(population ?? 0)
        - Area: \(area_sq_km ?? 0)
        - Languages: \(languages)
        - Currency: \(currency ?? "")
        - Major cities: \(cities)
        - Interesting facts: \(interests)
        """
    }
}
