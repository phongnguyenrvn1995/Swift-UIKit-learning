import UIKit
import PlaygroundSupport

/*let name = "Taylor"

for letter in name {
    print("Give me a \(letter)")
}


let letter = name[name.index(name.startIndex, offsetBy: 3)]

extension String {
    subscript(i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
}

let letter2 = name[3]*/

/*let password = "12345"
password.hasPrefix("123")
password.hasSuffix("345")

extension String {
    func deletePrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    func deleteSubfix(_ subfix: String) -> String {
        guard self.hasSuffix(subfix) else { return self }
        return String(self.dropLast(subfix.count))
    }
}
*/

/*let weather = "it's going to rAin"
print(weather.capitalized)

extension String {
    var capitalizedFirst: String {
        guard let firstLetter = self.first else { return "" }
        return firstLetter.uppercased() + self.dropFirst()
    }
}
weather.capitalizedFirst*/

/*let input = "Swift is Objective-C without the C"
input.contains("Swift")

let languages = ["Python", "Ruby", "Swift"]
languages.contains("Swift")

languages.contains(where: input.contains)*/

