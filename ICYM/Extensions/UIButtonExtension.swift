//
//  UIButtonExtension.swift
//  ICYM
//
//  Created by Dharani Reddy on 18/11/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import Foundation
import UIKit

class BlueShadowButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = nil
        let shadowPath = UIBezierPath(rect: CGRect(x: 0 , y: 0, width: frame.size.width, height: frame.size.height))
        layer.shadowColor =  UIColor.blue.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.45
        layer.shadowPath = shadowPath.cgPath
    }
}

class BlackBorderView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }
}
