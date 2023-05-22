import UIKit

/*class Singer {
    func playSong() {
        print("Shake it off!")
    }
}

func sing() -> () -> Void? {
    let taylor = Singer()
    let adele = Singer()
    let method = { [weak taylor, unowned adele] in
        taylor?.playSong()
        adele.playSong()
    }
    return method
}

//sing()("Java", 100)

var numberOfLineLogged = 0;
let log1 = {
    numberOfLineLogged += 1
    print("Line logged is \(numberOfLineLogged)")
}

let log2 = log1

log1()
log2()
*/

let checker = UITextChecker()
let word = "The quick bown fox jumps over the lazy dog"
let range = NSRange(location: 0, length: word.count)

let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

if misspelledRange.location != NSNotFound {
    let misspelledWord = (word as NSString).substring(with: misspelledRange)
    print("Misspelled word: \(misspelledWord)")
} else {
    print("No misspelled words found.")
}
