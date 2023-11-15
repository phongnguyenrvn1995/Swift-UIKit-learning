//
//  Note.swift
//  Notes
//
//  Created by Phong Nguyễn Hoàng on 14/11/2023.
//

import UIKit

class Note: NSObject, Codable {
    var id: String = UUID().uuidString
    var content: String?
    var dateTime: String?
    var title: String? {
        content?.components(separatedBy: "\n").first
    }
    var body: String? {
        var array = content?.components(separatedBy: "\n")
        array?.remove(at: 0)
        return array?.joined(separator: "\n")
    }
}
