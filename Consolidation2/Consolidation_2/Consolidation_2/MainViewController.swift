//
//  ViewController.swift
//  Consolidation_2
//
//  Created by Phong Nguyễn Hoàng on 21/04/2023.
//

import UIKit

class MainViewController: UITableViewController {
    var flags = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadPageInfo()
        loadFlags()
    }
    
    func loadPageInfo() {
//        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Flags Collection"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        flags.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",  for: indexPath) as! FlagTableViewCell
//        cell.contentView. = UIImageView(image: flags[0])
        cell.myImage?.image = UIImage(named: flags[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "detailViewController") as? DetailViewController {
            vc.imageName = flags[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func loadFlags() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let names = try? fm.contentsOfDirectory(atPath: path)
        if let names = names {
            names.filter { i -> Bool in
                return i.hasSuffix("@2x.png") && !i.uppercased().contains("APPICON")
            }.forEach { i in
                print(i)
                flags += [i]
            }
        }
    }
}

