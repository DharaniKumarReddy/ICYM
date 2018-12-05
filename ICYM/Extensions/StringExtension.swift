//
//  StringExtension.swift
//  Franziskaner Munchen
//
//  Created by Dharani Reddy on 19/04/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func downloadImage(completion: @escaping (UIImage) -> ()) {
        URLSession.shared.dataTask(with: NSURL(string:self)! as URL) {
            (data, response, error) in
            if let data = data {
                completion(UIImage(data: data) ?? #imageLiteral(resourceName: "default_image"))
            } else {
                completion(#imageLiteral(resourceName: "default_image"))
            }
        }.resume()
    }
}

func truncateCharactersInNotificationMessage(_ alertMessage:NSString) -> String {
    var message = alertMessage
    if message.length > 235 {
        message = message.substring(with: NSRange(location: 0, length: 235)) as NSString
    }
    return message as String
}
