//
//  InitTableViewController.swift
//  Project 4
//
//  Created by Phong Nguyễn Hoàng on 07/05/2023.
//

import UIKit

class InitTableViewController: UITableViewController {
    
    static var websites: [String] = ["google.com",
                                     "apple.com",
                                     "hackingwithswift.com",
                                     "zing.vn",
                                     "youtube.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Choose website to visit"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return InitTableViewController.websites.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "web_items", for: indexPath)
        cell.textLabel?.text = InitTableViewController.websites[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "main_vc")
        if let vc = vc as? ViewController {
            vc.initIndex = indexPath.row
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
