//
//  DetailViewController.swift
//  Milestone Projects 13-15
//
//  Created by Phong Nguyễn Hoàng on 21/09/2023.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var flag: UIImageView!
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var capital: UILabel!
    
    @IBOutlet var superficies: UILabel!
    
    @IBOutlet var population: UILabel!
    
    @IBOutlet var currency: UILabel!
    
    var country: Country!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = country.name
        
        name.text = country.name
        name.isHidden = true
        capital.text = country.capital
        superficies.text = "\(country.area_sq_km ?? 0) Km2"
        population.text = "\(country.population ?? 0)"
        currency.text = country.currency
        performSelector(inBackground: #selector(loadFlag), with: nil)
        
        setupShare()
    }
    
    func setupShare() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(onShareTaped))
    }
    
    @objc func onShareTaped() {
        var items: [Any] = ["\(country.description)"]
        if let img = flag.image?.jpegData(compressionQuality: 1) {
            items.insert(img, at: 0)
        }
        let vc = UIActivityViewController(activityItems: items, applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    @objc func loadFlag() {
        if let flag_url = country.flag_url {
            if let url = URL(string: flag_url) {
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.flag.image = image
                        }
                    }
                }
            }
        }
    }
}
