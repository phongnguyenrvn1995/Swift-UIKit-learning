//
//  ViewController.swift
//  Project 5
//
//  Created by Phong Nguyễn Hoàng on 11/05/2023.
//

import UIKit

class ViewController: UITableViewController {

    var allWords = [String]()
    var usedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("viewDidLoad()")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(confirm2Restart))
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            print("startWordsURL = \(startWordsURL)")
            if let startWords = try? String(contentsOf: startWordsURL) {
//                print(startWords)
                allWords = startWords.components(separatedBy: "\n")
                print(allWords)
            }
        }
        
        if(allWords.isEmpty) {
            allWords = ["silkworm"]
        }
        
        startGame()
    }
    
    @objc func confirm2Restart() {
        let ac = UIAlertController(title: "Restart game", message: "Are you sure?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "YES", style: .default) { [weak self] _ in
            self?.startGame()
        })
        ac.addAction(UIAlertAction(title: "NO", style: .destructive))
        present(ac, animated: true)
    }
    
    func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let ac = ac else { return }
            guard let answer = ac.textFields?[0].text else { return }
            self?.submit(answer)
        })
//        print("before present")
        present(ac, animated: true)
//        print("after present")
    }
    
    func submit(_ answer: String) {
        let lowerCase = answer.lowercased()
        if(!isPossible(lowerCase)) {
            errorNotify(title: "Word not possible", body: "You can't spell that word from \(title!)")
            return
        }
        if(!isOriginal(lowerCase)) {
            errorNotify(title: "Word used already", body: "Be more original!")
            return
        }
        if(!isReal(lowerCase)) {
            errorNotify(title: "Word not recognised", body: "You can't make them up, you know!")
            return
        }
        if(isTheSameAsTitle(lowerCase)) {
            errorNotify(title: "Word not possible", body: "Word must be not the same as the start word")
            return
        }
        if(!isEnoughLetters(lowerCase)) {
            errorNotify(title: "Word not possible", body: "The length must be greater than 3")
            return
        }
            
        usedWords.insert(lowerCase, at: 0)
        let path = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [path], with: .automatic)
    }
    
    func errorNotify(title: String, body: String) {
        let ac = UIAlertController(title: title, message: body, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func isPossible(_ answer: String) -> Bool {
        guard var tempWord = title else { return false }
        for item in answer {
            let position = tempWord.firstIndex(of: item)
            if let position = position {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        return true
    }
    
    func isOriginal(_ answer: String) -> Bool {
        return !usedWords.contains(answer)
    }
    
    func isReal(_ answer: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: answer.utf16.count)
        let ret = checker.rangeOfMisspelledWord(in: answer, range: range, startingAt: 0, wrap: false, language: "en")
        
        return ret.location == NSNotFound
    }
    
    func isEnoughLetters(_ answer: String) -> Bool {
        return answer.utf16.count > 3
    }
    
    func isTheSameAsTitle(_ answer: String) -> Bool {
        return answer.lowercased() == title?.lowercased()
    }
}

