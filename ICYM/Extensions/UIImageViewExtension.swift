//
//  UIImageViewExtension.swift
//  Franziskaner Munchen
//
//  Created by Dharani Reddy on 17/04/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func downloadImageFrom(link:String, contentMode: UIView.ContentMode) {
        if image == nil {
            image = #imageLiteral(resourceName: "default_image")
        }
        URLSession.shared.dataTask( with: NSURL(string:link)! as URL, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                self.contentMode =  contentMode
                if let data = data {
                    self.image = UIImage(data: data)
                } else {
                    self.image = #imageLiteral(resourceName: "default_image")
                }
            }
        }).resume()
    }
}

class RoundedBorderImage: UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = layer.bounds.height/2
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
    }
}
