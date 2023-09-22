//
//  ViewController.swift
//  Milestone Projects 13-15
//
//  Created by Phong Nguyễn Hoàng on 19/09/2023.
//

import UIKit

class ViewController: UITableViewController {
    var countries : [Country] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Countries"
        navigationController?.navigationBar.prefersLargeTitles = true
        if let url = Bundle.main.url(forResource: "countries", withExtension: "txt") {
            if let data = try? Data(contentsOf: url) {
                let jsonDecoder = JSONDecoder()
                if let listCountries = try? jsonDecoder.decode([Country].self, from: data) {
                    countries = listCountries
                }
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        navigationItem.largeTitleDisplayMode = .always
        coordinator.animate(alongsideTransition: { (_) in
            self.navigationController?.navigationBar.sizeToFit()
        }, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Country") as? CountryCell {
            let country = countries[indexPath.row]
            cell.title.text = country.name
            cell.detail.text = country.interesting_facts[0]
            cell.loadImage(url: country.flag_url)
            print(country)
            return cell
        }
        fatalError("Can't parse cell")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "detailview") as? DetailViewController {
            detailVC.country = countries[indexPath.row]
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

