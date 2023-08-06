//
//  ViewController.swift
//  Project 1
//
//  Created by Phong Nguyễn Hoàng on 08/03/2023.
//

import UIKit

class ViewController: UITableViewController {

    private var pictures = [String] ()
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        title = "View List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(onActionBtnTap))
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let fm = FileManager.default
            let path = Bundle.main.resourcePath!
            let items = try! fm.contentsOfDirectory(atPath: path)
            for item in items.sorted(by: { a, b in
                a < b
            }) {
                if item.hasPrefix("nssl") {
                    self?.pictures.append(item)
                }
            }
            print(self?.pictures ?? "")
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("pictures.count = \(pictures.count)")
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        cell.textLabel?.textColor = UIColor.blue
        
        let numOfViews = (getNumOfView(by: pictures[indexPath.row]))
        cell.detailTextLabel?.text = "\(numOfViews) \(numOfViews > 1 ? "views" : "view")"
        return cell
    }
    
    func getNumOfView(by pictureName: String) -> Int {
        let defaults = UserDefaults.standard
        return defaults.integer(forKey: pictureName)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.detail = "Picture \(indexPath.row + 1) of \(pictures.count)"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func onActionBtnTap() {
        let ac = UIActivityViewController(activityItems: ["Project 1"], applicationActivities: [])
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
}

