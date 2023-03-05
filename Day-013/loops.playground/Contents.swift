import UIKit

for i in 1...10 {
    print("\(i) x 10 = \(i * 10)")
}

/*Looping over arrays*/
var songs: [String]
songs = ["Nợ", "Hết", "Mơ"]
for song in songs {
    print(song)
}

for i in 0..<songs.count {
    print("\(songs[i])")
}

/*Inner loops*/
/*While loops*/
var counter = 0
while true {
    counter += 1
    if counter >= 100 && counter <= 200 {
        continue
    }
    print("Counter now is \(counter)")
    if counter == 556 {
        break
    }
}
