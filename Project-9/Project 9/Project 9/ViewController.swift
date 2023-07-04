//
//  ViewController.swift
//  Project 7
//
//  Created by Phong Nguyễn Hoàng on 01/06/2023.
//

import UIKit

class ViewController: UITableViewController {

    var petition = [Petition] ()
    var allPetition = [Petition] ()
    var filterString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupBar()
        performSelector(inBackground: #selector(loadData), with: nil)
    }
    
    @objc func loadData() {
        var urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        if navigationController?.tabBarItem.tag != 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                print("data: \(data)")
                parse(data: data)
                filterString = ""
                filter()
                return
            }
        }
        
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    func setupBar() {
        let creditBtn = UIBarButtonItem(image: UIImage(systemName: "creditcard"), style: .done, target: self, action: #selector(creditInfo))
        let searchBtn = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .done, target: self, action: #selector(searchTaped))
        navigationItem.rightBarButtonItems = [creditBtn, searchBtn]
        
        navigationItem.title = "All petitions"
    }
    
    @objc func creditInfo() {
        let ac = UIAlertController(
            title: "Info",
            message: "We The People API of the Whitehouse",
            preferredStyle: UIAlertController.Style.alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func searchTaped() {
        let ac = UIAlertController(title: "Search", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [unowned ac, weak self] _ in
            if let str = ac.textFields?[0].text {
                self?.filterString = str.lowercased().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                self?.filter()
            }
        })
        ac.addAction(UIAlertAction(title: "View all", style: .default) {[weak self] _ in
            self?.loadData()
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }

    func parse(data: Data) {
        let decoder = JSONDecoder()
        if let petitions = try? decoder.decode(Petitions.self, from: data) {
            allPetition = petitions.results
//            tableView.reloadData()
        }
    }
    
    func filter() {
        DispatchQueue.main.async { [weak self] in
            if(!(self?.filterString.isEmpty ?? false) == true) {
                self?.navigationItem.title = "Search: \(self?.filterString ?? "")"
            } else {
                self?.navigationItem.title = "All petitions"
            }
        }
        
        petition = allPetition.filter({ petition in
            filterString.isEmpty
            || petition.body.lowercased().contains(filterString.lowercased())
            || petition.title.contains(filterString.lowercased())
            || "\(petition.signatureCount)".contains(filterString.lowercased())
        })
        
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
//            self?.tableView.reloadData()
        
    }
    
    @objc func showError() {
        let ac = UIAlertController(title: "Somethings wrong", message: "There were some issues while loading the website, please try again", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        petition.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = petition[indexPath.row]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = DetailViewController()
        detail.petition = petition[indexPath.row]
        navigationController?.pushViewController(detail, animated: true)
    }
}

