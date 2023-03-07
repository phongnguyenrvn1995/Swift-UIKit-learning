import UIKit

class Album {
    var name: String
    init(name: String) {
        self.name = name
    }
    
    func getPerformance() -> String {
        "The album \(name) sold lots"
    }
}

class StudioAlbum : Album {
    var studio: String
    init(name: String, studio: String) {
        self.studio = studio
        super.init(name: name)
    }
    
    override func getPerformance() -> String {
        "The studio album \(name) sold lots"
    }
}

class LiveAlbum : Album {
    var localion: String
    init(name: String, location: String) {
        self.localion = location
        super.init(name: name)
    }
    
    override func getPerformance() -> String {
        "The live album \(name) sold lots"
    }
}

var taylorSwift = StudioAlbum(name: "Taylor Swift", studio: "The Castles Studios")
var fearless = StudioAlbum(name: "Speak Now", studio: "Aimeeland Studio")
var iTunesLive = LiveAlbum(name: "iTunes Live from SoHo", location: "New York")
var allAlbums: [Album] = [taylorSwift, fearless, iTunesLive]

//var casting = iTunesLive as? StudioAlbum ?? StudioAlbum(name: "", studio: "")
let num = 5
let string = String(num)
let float = Float(num)
let double = Double(num)

