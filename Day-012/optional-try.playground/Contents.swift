import UIKit

enum PasswordError: Error {
    case obvious
}

func checkPassword(_ pwd: String) throws -> Bool {
    if pwd == "password" {
        throw PasswordError.obvious
    }
    return true
}


let j = try? checkPassword("password") // nil
let i = try! checkPassword("password") // throw error
