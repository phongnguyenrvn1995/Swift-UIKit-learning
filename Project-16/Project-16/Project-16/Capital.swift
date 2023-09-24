//
//  Capital.swift
//  Project-16
//
//  Created by Phong Nguyễn Hoàng on 23/09/2023.
//

import UIKit
import MapKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    var tintColour: UIColor
    var url: URL?
    init(title: String, coordinate: CLLocationCoordinate2D, info: String, tintColour: UIColor = UIColor.black, url: URL? = nil) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
        self.tintColour = tintColour
        self.url = url
    }
}
