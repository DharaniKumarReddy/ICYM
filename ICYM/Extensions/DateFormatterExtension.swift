//
//  DateFormatterExtension.swift
//  Franziskaner Munchen
//
//  Created by Dharani Reddy on 18/04/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import Foundation

extension DateFormatter {
    convenience init(dateFormat: String) {
        self.init()
        self.dateFormat = dateFormat
    }
}

var dateFormattersMap: [String : DateFormatter] = [:]

func dateFormatter(_ format: String) -> DateFormatter {
    if let dateFormatter = dateFormattersMap[format] {
        return dateFormatter
    } else {
        let dateFormatter = DateFormatter(dateFormat: format)
        dateFormattersMap[format] = dateFormatter
        return dateFormatter
    }
}

class DateFormatters {
    
    class func defaultDateFormatter() -> DateFormatter {
        return dateFormatter("yyyy-MM-dd HH:mm:ss")
    }
}
