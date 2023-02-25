import UIKit

struct Student {
    static var classSize = 0
    var name: String
    init (name: String) {
        self.name = name
        Student.classSize += 1
    }
}

Student(name: "Swift")
Student(name: "Kotlin")
Student(name: "Java")
print(Student.classSize)
