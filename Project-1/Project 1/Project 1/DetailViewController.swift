//
//  DetailViewController.swift
//  Project 1
//
//  Created by Phong Nguyễn Hoàng on 13/03/2023.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    public var selectedImage: String?
    public var detail: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = detail
        navigationItem.largeTitleDisplayMode = .never
        if let selectedImage = selectedImage {
            imageView.image = UIImage(named: selectedImage)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("viewDidDisappear")
        navigationController?.hidesBarsOnTap = false
    }
}
