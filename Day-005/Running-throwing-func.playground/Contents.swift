import UIKit

enum NameError: Error {
    case emptyName
}

func sayHello(_ name: String) throws {
    if(name == "") {
        throw NameError.emptyName
    }
    print("Hello \(name)")
}

do {
    try sayHello("")
} catch {
    print(error)
}
