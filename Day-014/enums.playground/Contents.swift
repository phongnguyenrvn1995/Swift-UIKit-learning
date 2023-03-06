import UIKit

enum WeatherType {
    case sun
    case cloud
    case rain
    case wind (speed: Int)
    case snow
}

func getHaterStatus(weather: WeatherType) -> String? {
    switch weather {
    case .sun: return nil
    case .wind(let sp) where sp < 10: return "meh"
    case .wind, .cloud: return "Dislike"
    case .rain: return "Hate"
    case .snow: return "Yeah"
    }
}

getHaterStatus(weather: WeatherType.wind(speed: 9))

func checkStringEnum(string: String?) {
    switch string {
    case .none: print("I am nil")
    case .some(let string): print("I am \(string)")
    }
}
