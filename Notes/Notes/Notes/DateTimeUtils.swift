//
//  DateTimeUtils.swift
//  Notes
//
//  Created by Phong Nguyễn Hoàng on 15/11/2023.
//

import UIKit

class DateTimeUtils {
    
    static let dtf = DateFormatter()
    static let fmt = "HH:mm:ss dd-MM-yyyy"
    static func currentDateTime() -> String {
        dtf.dateFormat = fmt
        return dtf.string(from: Date())
    }
    
    static func change(srcFmt: String = fmt, src: String, desFmt: String) -> String? {
        dtf.dateFormat = fmt
        if let date = dtf.date(from: src) {
            print(date)
            dtf.dateFormat = desFmt
            return dtf.string(from: date)
        }
        return nil
    }
}
