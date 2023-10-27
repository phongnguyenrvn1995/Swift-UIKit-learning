//
//  ActionViewController.swift
//  Extension
//
//  Created by Phong Nguyễn Hoàng on 17/10/2023.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController, ListScriptVCDelegate {
    
    @IBOutlet var script: UITextView!
    var pageURL: String!
    var pageTitle: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        let notificationCeter = NotificationCenter.default
        notificationCeter.addObserver(self, selector: #selector(adjust4Keyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCeter.addObserver(self, selector: #selector(adjust4Keyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] dict, error in
                    guard let dict = dict as? NSDictionary else { return }
                    guard let javaScriptValues = dict[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.restoreScriptWithHost(urlStr: self?.pageURL)
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                    }
                }
            }
        }
    }
    
    @objc func showSamples() {
        let ac = UIAlertController(title: "Sample blocks", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Alert", style: .default) { [weak self] _ in
            self?.script.text = "alert(document.URL)"
        })
        ac.addAction(UIAlertAction(title: "Google.com", style: .default) { [weak self] _ in
            self?.script.text = "location.href='https://www.google.com'"
        })
        ac.addAction(UIAlertAction(title: "Red background", style: .default) { [weak self] _ in
            self?.script.text = "document.body.style.background = 'red'"
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func adjust4Keyboard(notification: Notification) {
        guard let dict = notification.userInfo else { return }
        guard let nsVal = dict[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = nsVal.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height + view.safeAreaInsets.bottom, right: 0)
        }
        script.scrollIndicatorInsets = script.contentInset
        let selectedRange = script.selectedRange
        print("Selected Range: \(selectedRange)")
        script.scrollRangeToVisible(selectedRange)
    }

    @IBAction func done() {
        backUpScriptWithHost()
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script.text ?? ""]
        let webDict: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let provider = NSItemProvider(item: webDict, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [provider]
        extensionContext?.completeRequest(returningItems: [item])
    }
    
    func backUpScriptWithHost() {
        guard let script = script.text else { return }
        guard let pageURL = pageURL else { return }
        print("pageURL \(pageURL)")
        guard let host = URL(string: pageURL)?.host else { return }
        print("host \(host)")
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(script, forKey: host)
    }
    
    func restoreScriptWithHost(urlStr: String?) {
        guard let urlStr = urlStr else { return }
        guard let host = URL(string: urlStr)?.host else { return }
        let userDefaults = UserDefaults.standard
        
        if let script = userDefaults.string(forKey: host) {
            DispatchQueue.main.async { [weak self] in
                self?.script.text = script
            }
        }
    }
    
    @IBAction func btnSampleTapped(_ sender: Any) {
        showSamples()
    }
    
    @IBAction func btnLoadTapped(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "listScriptVC") as? ListScriptViewController {
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnSaveTapped(_ sender: Any) {
        let ac = UIAlertController(title: "Save script", message: "Enter your srcipt name:", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Save", style: .default) { [weak self, weak ac] _ in
            guard let name =  ac?.textFields?[0].text else { return }
            guard let script = self?.script.text else { return }
            let sc = Script(name: name, script: script)
            ScriptUtils.append(script: sc)
        })
        present(ac, animated: true)
    }
    
    func hookBack(sc: Script) {
        script.text = sc.script
    }
}
