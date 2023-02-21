import UIKit

struct City {
    var population: Int
    
    func collectTaxes() -> Int {
        return population * 1000
    }
}

var city = City(population: 2000)
print(city.collectTaxes())
