//
//  ViewController.swift
//  Project-2
//
//  Created by Phong Nguyễn Hoàng on 17/03/2023.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var totalQuestions = 0
    var maxQuestions = 3
    var correctAnswer: Int! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Bundle.main.resourcePath ?? "")
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        askQuestion()
        initBarButton()
        scheduleReminders()
    }
    
    func scheduleReminders() {
        let content = UNMutableNotificationContent()
        content.title = "Flag guessing"
        content.body = "Play me today?"
        content.sound = .default
        content.badge = 1
        
        var dateComponent = DateComponents()
        let date = Date()
        dateComponent.hour = Calendar.current.component(.hour, from: date)
        dateComponent.minute = Calendar.current.component(.minute, from: date)
        dateComponent.second = Calendar.current.component(.second, from: date) + 3
        
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
        for i in 1...7 {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval((24 * 60 * 60 * i)), repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            center.add(request)
        }
    }
    
    func initBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(onActionButtonTap))
    }

    func askQuestion() {
        countries.shuffle();
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: UIControl.State.normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        showTitleWithScore()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String?
        var msg: String! = nil
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
            msg = "Your score is \(score)"
        } else {
            title = "Wrong"
            score -= 1
            msg = "That's the flag of \(countries[sender.tag].uppercased())"
        }
        
        showTitleWithScore()
        
        
        let ac = UIAlertController(title: title,
                                   message: msg, preferredStyle: UIAlertController.Style.alert)
        ac.addAction(UIAlertAction(title: "Continue",
                                   style: UIAlertAction.Style.default,
                                   handler: { _ in
            self.totalQuestions += 1;
            if(self.isHasNext()) {
                self.askQuestion()
            } else {
                self.summaryResult()
            }
        }))
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 5, animations: { [weak sender] in
            sender?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { [weak self, weak sender] _ in
            self?.present(ac, animated: true)
            sender?.transform = .identity
        }
    }
    
    private func showTitleWithScore() {
        title = countries[correctAnswer].uppercased() + " [\(score)]"
    }
    
    private func isHasNext() -> Bool {
        return totalQuestions < maxQuestions
    }
    
    private func summaryResult() {
        let ac = UIAlertController(title: "Game over",
                                   message: "You have completed \(maxQuestions) questions, and your final score is \(score)", preferredStyle: UIAlertController.Style.alert)
        ac.addAction(UIAlertAction(title: "Play again", style: .destructive, handler: { _ in
            self.score = 0
            self.totalQuestions = 0
            self.maxQuestions += 1
            self.askQuestion()
        }))
        present(ac, animated: true)
    }
    
    @objc func onActionButtonTap() {
        let ac = UIAlertController(title: "Score", message: "Your current score is \(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(ac, animated: true)
    }
}

