//
//  Helper.swift
//  ICYM
//
//  Created by Dharani Reddy on 23/11/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import Foundation

class Helper {
    class func richHtmlAttributeConversion(content: String, fontName: String, fontSize: Int, hexColor: String) -> NSAttributedString? {
        let htmlContent = String(format:"<span style=\"color:%@;font-family: '-apple-system', '%@'; font-size: %@\">%@</span>", hexColor, fontName, "\(fontSize)",content)
        do {
            let attributedString = try NSMutableAttributedString(data: htmlContent.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            return attributedString
        } catch {
            print(error)
        }
        return nil
    }
}
