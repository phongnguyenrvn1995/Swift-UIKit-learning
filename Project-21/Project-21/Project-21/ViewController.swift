//
//  ViewController.swift
//  Project-21
//
//  Created by Phong Nguyễn Hoàng on 29/10/2023.
//
import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    var action: String = "show"
    var userInfo: [AnyHashable : Any]? = nil
    var timeInterval: TimeInterval = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
        print("viewDidLoad")
        
        NotificationCenter.default.addObserver(self, selector: #selector(onResume), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onPause), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc func onResume(notify: Notification) {
        print("onResume \(notify.name)")
    }
    
    @objc func onPause(notify: Notification) {
        print("onPause \(notify.name)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
    }

    
    @objc func scheduleLocal() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "My title"
        content.body = "My body"
        content.categoryIdentifier = "tag"
        content.userInfo = ["my_info": "Ex155"]
        content.sound = .default
        
        var dateComponent = DateComponents()
        dateComponent.hour = 10
        dateComponent.minute = 30
        
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func showNotification() {
        let ac = UIAlertController(title: "Handler", message: "For action \(action)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

