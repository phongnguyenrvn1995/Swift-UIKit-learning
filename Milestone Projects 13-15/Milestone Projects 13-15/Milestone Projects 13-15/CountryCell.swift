//
//  CountryCell.swift
//  Milestone Projects 13-15
//
//  Created by Phong Nguyễn Hoàng on 20/09/2023.
//

import UIKit

class CountryCell: UITableViewCell {
    @IBOutlet var flagImage: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var detail: UILabel!
    
    override func didMoveToSuperview() {
        flagImage.layer.borderColor = UIColor.black.cgColor
        flagImage.layer.borderWidth = 1
    }
    
    func loadImage(url: String?) {
        guard let url = url else { return }
        if let url = URL(string: url) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.flagImage.image = image
                    }
                }
            }
        }
    }
}
