//
//  ImageViewController.swift
//  Day 50
//
//  Created by Phong Nguyễn Hoàng on 12/08/2023.
//

import UIKit

class ImageViewController: UIViewController {
    var favourite: Favourite!

    @IBOutlet var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = favourite.name
        
    
        let dateTimeLabel = UILabel()
        dateTimeLabel.text = favourite.date
        let barBtn = UIBarButtonItem(customView: dateTimeLabel)
        barBtn.customView?.sizeToFit()
        
        
        toolbarItems = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                        barBtn,
                        UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),]
        
        
        initImage()
    }
    
    func initImage() {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(favourite.link)
        imageView.image = UIImage(contentsOfFile: url.path)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnTap = true
        navigationController?.isToolbarHidden = false
    }
}
