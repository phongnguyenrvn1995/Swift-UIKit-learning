//
//  RadiusTableViewCell.swift
//  Notes
//
//  Created by Phong Nguyễn Hoàng on 06/11/2023.
//

import UIKit

class RadiusTableViewCell: UITableViewCell {
    
    var doSomethingsInLayoutSubviews: (() -> Void)?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = UIColor(white: 0.5, alpha: 0.2)
        doSomethingsInLayoutSubviews?()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension UITableViewCell {
    func roundCorners(corners: UIRectCorner, radius: Int) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
}
