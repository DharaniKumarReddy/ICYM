//
//  UIApplicationExtension.swift
//  Franziskaner Munchen
//
//  Created by Dharani Reddy on 30/09/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    class func topViewController() -> UIViewController? {
        let topController = (UIApplication.shared.keyWindow?.rootViewController?.children.first as? UINavigationController)?.visibleViewController
        if topController?.children.count != 0 {
            return topController?.children.last
        } else {
            return topController
        }
    }
}
