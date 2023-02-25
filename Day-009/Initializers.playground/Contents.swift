import UIKit

struct User {
    var username: String
    init(a: String) {
        username = a
    }
}

var user = User(a: "Kotlin")
print(user.username)
