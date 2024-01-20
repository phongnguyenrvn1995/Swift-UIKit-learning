//
//  ViewController.swift
//  Project-28
//
//  Created by Phong Nguyễn Hoàng on 20/01/2024.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    @IBOutlet var secret: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Nothing to see here"
        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "lock"), style: .done, target: self, action: #selector(saveSecretMessage))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyBoard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyBoard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
        
        KeychainWrapper.standard.set("123456", forKey: "password_auth")
    }
    
    @objc func adjustForKeyBoard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreeenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreeenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        secret.scrollIndicatorInsets = secret.contentInset
        secret.scrollRangeToVisible(secret.selectedRange)
    }
    
    @IBAction func authenticateTapped(_ sender: Any) {
        let ac = UIAlertController(title: "Select Authentication", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Biometry Authentication", style: .default, handler: { [weak self] _ in
            self?.biometryAuth()
        }))
        
        ac.addAction(UIAlertAction(title: "Password Authentication", style: .default, handler: { [weak self] _ in
            self?.passwordAuth()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func passwordAuth() {
        let ac = UIAlertController(title: "Input password", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak ac, weak self] _ in
            guard let pwd = ac?.textFields?[0].text else { return }
            guard let securePwd = KeychainWrapper.standard.string(forKey: "password_auth") else { return }
            if pwd == securePwd {
                self?.unblockSecretMessage()
            } else {
                let ac = UIAlertController(title: "Authentication Failed", message: "You could not be verified, please try again!", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(ac, animated: true)
            }
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: false)
    }
    
    func biometryAuth() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Identify yourself") { [weak self] isSuccess, authenticationError in
                DispatchQueue.main.async {
                    if isSuccess {
                        self?.unblockSecretMessage()
                    } else {
                        let ac = UIAlertController(title: "Authentication Failed", message: "You could not be verified, please try again!", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            // no biometry
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication! \(error?.localizedDescription ?? "")", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func unblockSecretMessage() {
        secret.isHidden = false
        title = "Secret stuff!"
        
        secret.text = KeychainWrapper.standard.string(forKey: "my_data") ?? ""
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    @objc func saveSecretMessage() {
        print("saveSecretMessage")
        guard secret.isHidden == false else { return }
        KeychainWrapper.standard.set(secret.text, forKey: "my_data")
        secret.resignFirstResponder()
        secret.isHidden = true
        title = "Nothing to see here"
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
}

