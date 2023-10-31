//
//  AppDelegate.swift
//  Project-21
//
//  Created by Phong Nguyễn Hoàng on 29/10/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var currentVC: ViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        registerLocal()
        registerCategories()
        return true
    }
    
    func registerLocal() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Yah!")
            } else {
                print("D'oh!")
            }
        }
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()            
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        let remind = UNNotificationAction(identifier: "remind", title: "Remind me later", options: .destructive)
        let category = UNNotificationCategory(identifier: "tag", actions: [show, remind], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
        print("registerCategories")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo // lấy thông tin đã gửi vào trước đó
        
        if let myInfo = userInfo["my_info"] as? String {
            print("Data received: \(myInfo)")
            switch(response.actionIdentifier) {
            case UNNotificationDefaultActionIdentifier: // event mặc định khi bấm vào notify mở app lên
                print("Default identifier")
                showNavigationVC(action: UNNotificationDefaultActionIdentifier, userInfo: userInfo)
            case "show": // sự kiện khi Tell me more... đc bấm
                print("Show more info...")
                showNavigationVC(action: "show", userInfo: userInfo)
            case "remind":
                print("remind later")
                remindLater()
            default:
                break
            }
        }
        completionHandler()
    }
    
    func remindLater() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "mainvc") as? ViewController {
            vc.timeInterval = 24 * 60 * 60
            vc.scheduleLocal()
        }
    }
    
    func showViewController(action: String, userInfo: [AnyHashable : Any]) {
        print("HERE")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "mainvc") as? ViewController {
            vc.action = action
            vc.userInfo = userInfo
            if let window = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                window.windows.first?.rootViewController = vc
                print("SHOWWWWWW")
                vc.showNotification()
            }
        }
    }
    
    func showNavigationVC(action: String, userInfo: [AnyHashable : Any]) {
        print("HERE")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let nVC = storyboard.instantiateViewController(withIdentifier: "mainNav") as? UINavigationController {
            
            if let window = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                window.windows.first?.rootViewController = nVC
                print("SHOWWWWWW")
                if let vc =  nVC.viewControllers.first as? ViewController {
                    vc.action = action
                    vc.userInfo = userInfo
                    vc.showNotification()
                }
            }
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

