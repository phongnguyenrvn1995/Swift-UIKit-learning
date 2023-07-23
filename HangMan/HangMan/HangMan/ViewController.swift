//
//  ViewController.swift
//  HangMan
//
//  Created by Phong Nguyễn Hoàng on 22/07/2023.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    var allWords = [String]()
    var scoreLabel = UILabel()
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)".uppercased()
        }
    }
    
    var wrongSignals = [UIView]()
    var wrongLettersView = [UILabel]()
    var secretLettersView = [UILabel]()
    var wrongSignalsViewContainer: UIView? = nil
    var wrongLettersViewContainer: UIView? = nil
    var secretLettersViewContainer: UIView? = nil
    
    var secrectLetters = "" {
        didSet {
            currentLetters = [Character]()
            for _ in secrectLetters {
                currentLetters.append(Character("_"))
            }
        }
    }
    var currentLetters: [Character] = [] {
        didSet {
            for (index, value) in currentLetters.enumerated() {
                if(secretLettersView.count >= index + 1) {
                    secretLettersView[index].text = "\(value)"
                }
            }
            if(!currentLetters.isEmpty && currentLetters.firstIndex(of: Character("_")) == nil) {
                //next level
                print("NEXT LEVEL \(currentLetters)")
                warningAlert(title: "Well done", msg: "Press OK to go to the next word") {[weak self] in
                    self?.initNewWord()
                    self?.score += 1
                }
            }
        }
    }
    var wrongLetters: [Character] = [] {
        didSet {
            for (index, value) in wrongLetters.enumerated() {
                if(wrongLettersView.count >= index - 1) {
                    wrongLettersView[index].isHidden = false
                    wrongLettersView[index].text = "\(value)"
                }
                if(wrongSignals.count >= wrongLetters.count) {
                    wrongSignals[wrongSignals.count - 1 - index].isHidden = true
                }
            }
            if(wrongLetters.count == 7) {
                //end game
                print("END GAME")
                warningAlert(title: "Game over", msg: "Press OK to restart game") { [weak self] in
                    self?.initNewWord()
                    self?.score = 0
                }
            }
        }
    }
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func initWrongSignal() {
        let sinalLabel = UILabel()
        sinalLabel.translatesAutoresizingMaskIntoConstraints = false
        sinalLabel.font = UIFont.systemFont(ofSize: 20)
        sinalLabel.text = "Health".uppercased()
        sinalLabel.textColor = .blue
        sinalLabel.layer.backgroundColor = UIColor(red: 0.75, green: 0.99, blue: 0.98, alpha: 1.00).cgColor
        view.addSubview(sinalLabel)
        
        
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.font = UIFont.systemFont(ofSize: 20)
        scoreLabel.text = "Score: 999".uppercased()
        scoreLabel.textColor = .blue
        scoreLabel.textAlignment = .right
        scoreLabel.layer.backgroundColor = UIColor(red: 0.75, green: 0.99, blue: 0.98, alpha: 1.00).cgColor
        view.addSubview(scoreLabel)
        
        let signalView = buildWrongSignalView()
        wrongSignalsViewContainer?.removeFromSuperview()
        wrongSignalsViewContainer = signalView
        view.addSubview(signalView)
        NSLayoutConstraint.activate([
            sinalLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            sinalLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            sinalLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
            
            scoreLabel.topAnchor.constraint(equalTo: sinalLabel.topAnchor),
            scoreLabel.leadingAnchor.constraint(equalTo: sinalLabel.trailingAnchor),
            scoreLabel.widthAnchor.constraint(equalTo: sinalLabel.widthAnchor),
            
            signalView.topAnchor.constraint(equalTo: sinalLabel.bottomAnchor),
            signalView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            signalView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor)
        ])
    }
    
    func buildWrongSignalView() -> UIView {
        wrongSignals.removeAll()
        for _ in 0 ..< 7 {
            let item = UIView()
            wrongSignals.append(item)
        }
        let signalView = UIView()
        signalView.translatesAutoresizingMaskIntoConstraints = false
        var theLastItemTrailingAnchor = signalView.leadingAnchor
        
        for (index, item) in wrongSignals.enumerated() {
            item.layer.backgroundColor = UIColor.green.cgColor
            item.translatesAutoresizingMaskIntoConstraints = false
            item.isHidden = false
            signalView.addSubview(item)
            NSLayoutConstraint.activate([
                item.topAnchor.constraint(equalTo: signalView.topAnchor),
                item.heightAnchor.constraint(equalTo: signalView.widthAnchor, multiplier: CGFloat(1.0 / (Float(wrongSignals.count))), constant: -5),
                item.widthAnchor.constraint(equalTo: item.heightAnchor),
                item.leadingAnchor.constraint(equalTo: theLastItemTrailingAnchor, constant: index == 0 ? 2.5 : 5)
            ])
            theLastItemTrailingAnchor = item.trailingAnchor
        }
        signalView.heightAnchor.constraint(equalTo: wrongSignals[0].heightAnchor).isActive = true
        return signalView
    }

    
    func initWrongLettersView() {
        let wrongLetterLabel = UILabel()
        wrongLetterLabel.translatesAutoresizingMaskIntoConstraints = false
        wrongLetterLabel.font = UIFont.systemFont(ofSize: 20)
        wrongLetterLabel.text = "Wrong letters".uppercased()
        wrongLetterLabel.textColor = .blue
        wrongLetterLabel.layer.backgroundColor = UIColor(red: 0.75, green: 0.99, blue: 0.98, alpha: 1.00).cgColor
        view.addSubview(wrongLetterLabel)
        
        let lettersView = buildWrongLettersView()
        wrongLettersViewContainer?.removeFromSuperview()
        wrongLettersViewContainer = lettersView
        view.addSubview(lettersView)
        
        NSLayoutConstraint.activate([
            wrongLetterLabel.topAnchor.constraint(equalTo: wrongSignals[0].bottomAnchor),
            wrongLetterLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            wrongLetterLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            lettersView.topAnchor.constraint(equalTo: wrongLetterLabel.bottomAnchor),
            lettersView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            lettersView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor)
        ])
    }
    
    func buildWrongLettersView() -> UIView {
        wrongLettersView.removeAll()
        for _ in 0 ..< 7 {
            let item = UILabel()
            wrongLettersView.append(item)
        }
        let lettersView = UIView()
        lettersView.translatesAutoresizingMaskIntoConstraints = false
        var theLastItemTrailingAnchor = lettersView.leadingAnchor
        
        for (index, item) in wrongLettersView.enumerated() {
//            item.layer.backgroundColor = UIColor.lightGray.cgColor
            item.layer.borderWidth = 1
            item.layer.borderColor = UIColor.red.cgColor
            item.translatesAutoresizingMaskIntoConstraints = false
            item.font = UIFont.boldSystemFont(ofSize: 25)
            item.textColor = UIColor.red
            item.textAlignment = .center
            item.text = "W"
            item.isHidden = true
            lettersView.addSubview(item)
            NSLayoutConstraint.activate([
                item.topAnchor.constraint(equalTo: lettersView.topAnchor),
                item.heightAnchor.constraint(equalTo: lettersView.widthAnchor, multiplier: CGFloat(1.0 / (Float(wrongLettersView.count))), constant: -5),
                item.widthAnchor.constraint(equalTo: item.heightAnchor),
                item.leadingAnchor.constraint(equalTo: theLastItemTrailingAnchor, constant: index == 0 ? 2.5 : 5)
            ])
            theLastItemTrailingAnchor = item.trailingAnchor
        }
        lettersView.heightAnchor.constraint(equalTo: wrongLettersView[0].heightAnchor).isActive = true
        return lettersView
    }
    
    func initSecretLettersView() {
        let secrectLetterLabel = UILabel()
        secrectLetterLabel.translatesAutoresizingMaskIntoConstraints = false
        secrectLetterLabel.font = UIFont.systemFont(ofSize: 20)
        secrectLetterLabel.text = "Secrect letters".uppercased()
        secrectLetterLabel.textColor = .blue
        secrectLetterLabel.layer.backgroundColor = UIColor(red: 0.75, green: 0.99, blue: 0.98, alpha: 1.00).cgColor
        view.addSubview(secrectLetterLabel)
        
        let secrectView = buildSecretLettersView()
        secretLettersViewContainer?.removeFromSuperview()
        secretLettersViewContainer = secrectView
        view.addSubview(secrectView)
        
        NSLayoutConstraint.activate([
            secrectLetterLabel.topAnchor.constraint(equalTo: wrongLettersView[0].bottomAnchor),
            secrectLetterLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            secrectLetterLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            secrectView.topAnchor.constraint(equalTo: secrectLetterLabel.bottomAnchor),
            secrectView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    func buildSecretLettersView() -> UIView {
        secretLettersView.removeAll()
        let width = 35
        let lengthOfLetters = secrectLetters.count
        let secrectView = UIView()
        secrectView.translatesAutoresizingMaskIntoConstraints = false
        
        for index in 0 ..< lengthOfLetters {
            let item = UILabel()
            item.layer.borderColor = UIColor.blue.cgColor
            item.layer.borderWidth = 1
            item.translatesAutoresizingMaskIntoConstraints = false
            item.text = "_"
            item.textColor = UIColor.purple
            item.textAlignment = .center
            item.font = UIFont.boldSystemFont(ofSize: 20)
            secrectView.addSubview(item)
            NSLayoutConstraint.activate([
                item.widthAnchor.constraint(equalToConstant: CGFloat(width)),
                item.heightAnchor.constraint(equalTo: item.widthAnchor),
                item.leadingAnchor.constraint(equalTo: secrectView.leadingAnchor, constant: CGFloat(index * (width)))
            ])
            secretLettersView.append(item)
        }
        
        NSLayoutConstraint.activate([
            secrectView.widthAnchor.constraint(equalToConstant: CGFloat((width) * lengthOfLetters)),
            secrectView.heightAnchor.constraint(equalToConstant: CGFloat(width))
        ])
        
        return secrectView
    }
    
    func initGuessButton() {
        let guessBtn = UIButton(type: .system)
        guessBtn.translatesAutoresizingMaskIntoConstraints = false
        guessBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        guessBtn.backgroundColor = UIColor(red: 0.01, green: 0.32, blue: 0.99, alpha: 1.00)
        guessBtn.setTitleColor(UIColor.white, for: .normal)
        guessBtn.layer.cornerRadius = 10
        guessBtn.setTitle("GUESS", for: .normal)
        guessBtn.addTarget(self, action: #selector(onGuessBtnPressed), for: .touchUpInside)
//        guessBtn.setContentCompressionResistancePriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(guessBtn)
        NSLayoutConstraint.activate([
            guessBtn.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            guessBtn.topAnchor.constraint(greaterThanOrEqualTo: secretLettersViewContainer!.bottomAnchor),
            guessBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            guessBtn.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    @objc func onGuessBtnPressed() {
        let ac = UIAlertController(title: "GUESSING", message: "Enter your character:", preferredStyle: .alert)
        
        ac.addTextField() { (textField: UITextField) -> Void in
            textField.delegate = self
        }
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            let string = ac?.textFields?[0].text?.uppercased()
            self?.guessProcessing(character: string?.first)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        present(ac, animated: true)
    }
    
    func guessProcessing(character: Character?) {
        guard let character = character else { return }
        if(currentLetters.contains(character)) {
            warningAlert(title: "Choose another character", msg: "\(character) is correct before")
            return
        }
        
        if(wrongLetters.contains(character)) {
            warningAlert(title: "Choose another character", msg: "\(character) is incorrect before")
            return
        }
        
        if(secrectLetters.firstIndex(of: character) == nil) {
            wrongLetters.append(character)
            return
        }
        unMaskCurrentLetters(character: character)
    }
    
    func unMaskCurrentLetters(character: Character) {
        for (index, value) in secrectLetters.enumerated() {
            if(value == character) {
                currentLetters[index] = character
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.utf16.count + string.utf16.count - range.length
        return newLength <= 1 // max length = 1
    }
    
    func warningAlert(title:String, msg: String, handler: (() -> Void)? = nil) {
        let ac = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            handler?()
        })
        present(ac, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if(loadWords()) {
            initNewWord()
            score = 0
        }
    }
    
    func initNewWord() {
        view.subviews.forEach { it in
            it.removeFromSuperview()
        }
        secrectLetters.removeAll()
        wrongLetters.removeAll()
        secrectLetters = allWords.shuffled().first!.uppercased()
        initWrongSignal()
        initWrongLettersView()
        initSecretLettersView()
        initGuessButton()
        print(secrectLetters)
        var hint = Array(secrectLetters)
        hint = Array(Set(hint))
        guessProcessing(character: hint.first)
        guessProcessing(character: hint.last)
    }
    
    func loadWords() -> Bool {
        guard let url = Bundle.main.url(forResource: "start", withExtension: "txt") else { return false }
        guard let allWordsString = try? String(contentsOf: url) else { return false }
        allWords = allWordsString.components(separatedBy: "\n")
//        print(allWords)
        return true
    }
}

