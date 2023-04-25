//
//  DetailViewController.swift
//  Consolidation_2
//
//  Created by Phong Nguyễn Hoàng on 22/04/2023.
//

import UIKit

class DetailViewController: UIViewController {

    public var imageName: String!
    @IBOutlet var txtDesc: UILabel!
    @IBOutlet var flagImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initBarMenu()
        loadImage()
        loadDescription()
    }
    
    func initBarMenu() {
        let btn = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareFlag))
        navigationItem.rightBarButtonItem = btn
    }
    
    @objc func shareFlag() {
        let img = UIImage(named: imageName)
        guard let img = img?.jpegData(compressionQuality: 1.0) else {
            return
        }
        
        let avc = UIActivityViewController(activityItems: [img], applicationActivities: [])
        avc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(avc, animated: true)
    }
    
    func loadImage() {
//        flagImage.layer.borderWidth = 1
        flagImage.image = UIImage(named: imageName)
    }
    
    func loadDescription() {
        guard let imageName = imageName else {
            return
        }
        let countryName = imageName.split(separator: "@")[0]
        txtDesc.text = "This is the flag of \(countryName.uppercased())"
    }
    
    @IBAction func onBackClick() {
        navigationController?.popViewController(animated: true)
    }
}
