import UIKit

class Singer {
    var name: String
    init(name: String) {
        self.name = name
    }
    
    func uppersName() {
        self.name = self.name.uppercased()
    }
}

let phuongThanh = Singer(name: "Phuong Thanh")
phuongThanh.name = "Phương Thanh"
phuongThanh.uppersName()
