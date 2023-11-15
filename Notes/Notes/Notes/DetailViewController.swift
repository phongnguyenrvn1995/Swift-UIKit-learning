//
//  DetailViewController.swift
//  Notes
//
//  Created by Phong Nguyễn Hoàng on 07/11/2023.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var content: UITextView!
    @IBOutlet var datetimeLabel: UITextField!
    var timer: Timer?
    var note: Note?
    private var initContent = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(save))
        navigationItem.rightBarButtonItem = doneBtn
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustKeyboard), name: UIApplication.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustKeyboard), name: UIApplication.keyboardWillChangeFrameNotification, object: nil)
        content.keyboardDismissMode = .interactive
        displayTime()
        initData()
    }
    
    func initData() {
        guard let note = note else {
            note = Note()
            return
        }
        content.text = note.content
        initContent = content.text
    }
    
    @objc func displayTime() {
        datetimeLabel.text = DateTimeUtils.currentDateTime()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(displayTime), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear")
        timer?.invalidate()
        save()
    }
    
    @objc func adjustKeyboard(notification: Notification) {
//        print("adjustKeyboard \(view.window?.bounds == nil ? "nil":"NOT ")")
        guard let dict = notification.userInfo else { return }
        guard let nSVal = dict[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrameScreen = nSVal.cgRectValue
        let keyboardFrameView = view.convert(keyboardFrameScreen, from: nil)
        if notification.name == UIApplication.keyboardWillHideNotification {
            content.contentInset = .zero
            
        } else if notification.name == UIApplication.keyboardWillChangeFrameNotification {
            content.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrameView.size.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        content.scrollIndicatorInsets = content.contentInset
        content.scrollRangeToVisible(content.selectedRange)
    }
    
    @objc func save() {
        dismissKeyBoard()
        if(content.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty 
           || initContent == content.text) {
            return
        }
        
//        let note = Note()
        note!.dateTime = datetimeLabel.text
        note!.content = content.text
        let rs = NoteUtils.save(note: note!)
        print(rs)
    }
    
    @objc func dismissKeyBoard() {
        view.endEditing(true)
    }
}
