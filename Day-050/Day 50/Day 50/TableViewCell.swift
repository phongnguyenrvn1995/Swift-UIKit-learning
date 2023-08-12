//
//  TableViewCell.swift
//  Day 50
//
//  Created by Phong Nguyễn Hoàng on 09/08/2023.
//

import UIKit

class TableViewCell: UITableViewCell {
    var favourite: Favourite? = nil {
        didSet {
            guard let favourite = favourite else { return }
            name.text = favourite.name
            date.text = favourite.date
            icon.image = UIImage(contentsOfFile: "\(getDocumentDir().appendingPathComponent(favourite.link).path)")
        }
    }
    
    var onDeletePress: ((Favourite) -> Void)? = nil

    @IBOutlet var icon: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var btnDel: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func getDocumentDir() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onDeleteTaped(_ sender: Any) {
        print("CLICKED")
        guard let favourite = favourite else { return }
        onDeletePress?(favourite)
    }
}
