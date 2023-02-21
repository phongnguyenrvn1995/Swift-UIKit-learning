import UIKit

struct Sport {
    var name: String
    var isOlympicSport: Bool
    var olympicStatus: String {
        if isOlympicSport {
            return "\(name) is olympic sport"
        } else {
            return "\(name) is not olympic sport"
        }
    }
}

let sport = Sport(name: "Soccer", isOlympicSport: true)
print(sport.olympicStatus)
