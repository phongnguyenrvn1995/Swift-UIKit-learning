//
//  ViewController.swift
//  Project 8
//
//  Created by Phong Nguyễn Hoàng on 20/06/2023.
//

import UIKit

class ViewController: UIViewController {

    var scoreLabel: UILabel!
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var letterButtons = [UIButton]()
    var letterButtonsShowing: Int {
        letterButtons.filter { btn in
            btn.isHidden == false
        }.count
    }
    
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    
    var level = 1
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.setContentHuggingPriority(UILayoutPriority(249), for: .vertical)
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.numberOfLines = 0
        cluesLabel.text = "CLUES"
//        cluesLabel.backgroundColor = UIColor.red
        view.addSubview(cluesLabel)
        
        answersLabel = UILabel()
        answersLabel.setContentHuggingPriority(UILayoutPriority(249), for: .vertical)
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.numberOfLines = 0
        answersLabel.textAlignment = .right
        answersLabel.text = "ANSWER"
//        answersLabel.backgroundColor = UIColor.blue
        view.addSubview(answersLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "TAP letters to guess..."
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.textAlignment = .center
        currentAnswer.isUserInteractionEnabled = false
//        currentAnswer.backgroundColor = .brown
        view.addSubview(currentAnswer)
        
        let submitBtn = UIButton(type: .system)
        submitBtn.translatesAutoresizingMaskIntoConstraints = false
        submitBtn.setTitle("SUBMIT", for: .normal)
        submitBtn.addTarget(self, action: #selector(onSubmitTapped), for: .touchUpInside)
        view.addSubview(submitBtn)
        
        let clearBtn = UIButton(type: .system)
        clearBtn.translatesAutoresizingMaskIntoConstraints = false
        clearBtn.setTitle("CLEAR", for: .normal)
        clearBtn.addTarget(self, action: #selector(onClearTapped), for: .touchUpInside)
        view.addSubview(clearBtn)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.layer.borderWidth = CGFloat(1)
        buttonsView.layer.borderColor = UIColor.blue.cgColor
//        buttonsView.backgroundColor = .blue
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.layoutMarginsGuide.bottomAnchor, constant: 20),
            
            submitBtn.topAnchor.constraint(equalTo: currentAnswer.layoutMarginsGuide.bottomAnchor),
            submitBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submitBtn.heightAnchor.constraint(equalToConstant: 44),
            clearBtn.topAnchor.constraint(equalTo: submitBtn.topAnchor),
            clearBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clearBtn.heightAnchor.constraint(equalTo: submitBtn.heightAnchor),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submitBtn.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
        
        letterButtons.removeAll()
        let height = 80, width = 150
        for row_ in 0...3 {
            for col_ in 0...4 {
                let letterBtn = UIButton(type: .system)
                letterBtn.setTitle("WWW", for: .normal)
                letterBtn.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterBtn.frame = CGRect(x: col_ * width, y: row_ * height, width: width, height: height)
//                letterBtn.backgroundColor = .yellow
                letterBtn.addTarget(self, action: #selector(onLetterTapped), for: .touchUpInside)
                buttonsView.addSubview(letterBtn)
                letterButtons.append(letterBtn)
            }
        }
    }
    
    func loadLevel() {
        solutions.removeAll()
        var clueDisplay = ""
        var solutionDisplay = ""
        var bitLetters = [String]()
        let resourceURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt")
        if let resourceURL = resourceURL {
            let data = try? String(contentsOf: resourceURL)
            if let data = data {
//                print(data) HA|UNT|ED: Ghosts in residence
                var lines = data.components(separatedBy: "\n")
                lines.shuffle()
//                print(lines)
                for (index, value) in lines.enumerated() {
                    let parts = value.components(separatedBy: ":")
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    clueDisplay += "\(index + 1). \(clue)\n"
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionDisplay += "\(solutionWord.utf16.count) letters\n"
                    solutions.append(solutionWord)
                    
                    let bits = answer.components(separatedBy: "|")
                    bitLetters += bits
                }
            }
        }
        
        cluesLabel.text = clueDisplay.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        answersLabel.text = solutionDisplay.trimmingCharacters(in: .whitespacesAndNewlines)
        
        bitLetters.shuffle()
        
        if(bitLetters.count == letterButtons.count) {
            for (index, item) in bitLetters.enumerated() {
                letterButtons[index].setTitle(item, for: .normal)
            }
        }
    }
    
    @objc func onLetterTapped(_ sender: UIButton) {
//        print("onLetterTapped \(sender)")
        guard let buttonTitle = sender.titleLabel?.text else { return }
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activatedButtons.append(sender)
        sender.isHidden = true
    }
    
    @objc func onClearTapped(_ sender: UIButton) {
//        print("onClearTapped \(sender)")
        currentAnswer.text = ""
        for item in activatedButtons {
            item.isHidden = false
        }
        
        activatedButtons.removeAll()
    }
    
    @objc func onSubmitTapped(_ sender: UIButton) {
//        print("onSubmitTapped \(sender)")
        guard let answerText = currentAnswer.text else { return }
        guard let solutionPosition = solutions.firstIndex(of: answerText) else {
            let ac = UIAlertController(title: "Opps", message: "Your answer is incorrect!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Double check", style: .default))
            present(ac, animated: true)
            score -= 1
            return
        }
        
        guard var splitAnswers = answersLabel.text?.components(separatedBy: "\n") else { return }
        splitAnswers[solutionPosition] = answerText
        answersLabel.text = splitAnswers.joined(separator: "\n")
        
        currentAnswer.text = ""
        score += 1
        activatedButtons.removeAll()
        
        if(letterButtonsShowing == 0) {
            let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
            present(ac, animated: true)
        }
    }
    
    func levelUp(_ action: UIAlertAction) {
        level += 1
        if(level > 2) {
            let ac = UIAlertController(title: "Game over", message: "The game is all over!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Restart level 1", style: .default))
            present(ac, animated: true)
            level = 1
        }
        
        loadLevel()
        for item in letterButtons {
            item.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadLevel()
    }
}
