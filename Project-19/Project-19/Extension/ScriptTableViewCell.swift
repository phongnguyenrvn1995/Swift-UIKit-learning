//
//  ScriptTableViewCell.swift
//  Extension
//
//  Created by Phong Nguyễn Hoàng on 27/10/2023.
//

import UIKit

class ScriptTableViewCell: UITableViewCell {
    var delegate: ScriptTableViewCellDelegate? = nil
    @IBOutlet var name: UILabel!
    var script: Script!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func onRemoveTapped(_ sender: Any) {
        delegate?.onRemoveTapped(script: script)
    }
}

protocol ScriptTableViewCellDelegate {
    func onRemoveTapped(script: Script)
}
