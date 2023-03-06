import UIKit

func favouriteAlbum() {
    print("My favourite album is Fearless")
}

func favouriteAlbum(name: String) {
    print("My favourite is \(name)")
}

func favouriteAlbum(name: String, year: Int) {
    print("My favourite is \(name) released in \(year)")
}

func favouriteAlbum(album: String, year: Int) {
    print("My favourite is \(album) released in \(year)")
}

favouriteAlbum()
favouriteAlbum(name: "Always with you")
favouriteAlbum(name: "Always with you", year: 2010)
favouriteAlbum(album: "Always with you", year: 2010)

/*External and internal parameter names*/
func favouriteAlbum(_ album: String, year: Int) {
    print("My favourite is \(album) released in \(year)")
}

favouriteAlbum("Sex and zen", year: 2000)

/*Return values*/
func sum(a: Int, b: Int) -> Int {
    a + b
}

func sum(a: Int) -> Int {
    sum(a: a, b: 0)
}
sum(a: 1, b: 2)
sum(a: 3)
    