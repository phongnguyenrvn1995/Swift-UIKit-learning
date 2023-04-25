//
//  FlagTableViewCell.swift
//  Consolidation_2
//
//  Created by Phong Nguyễn Hoàng on 22/04/2023.
//

import UIKit

class FlagTableViewCell: UITableViewCell {

    @IBOutlet var myImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        myImage.layer.borderColor = UIColor.black.cgColor
        myImage.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
