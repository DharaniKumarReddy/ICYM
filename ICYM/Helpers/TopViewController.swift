//
//  TopViewController.swift
//  Franziskaner Munchen
//
//  Created by Dharani Reddy on 30/09/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import Foundation
import UIKit

class TopViewController {
    class func isNotifiedController() -> Bool {
        switch PushNotificationHandler.sharedInstance.notificationType {
        case 1:
            return UIApplication.topViewController() is NewsViewController
        case 2:
            return UIApplication.topViewController() is NewsViewController
        case 3:
            return UIApplication.topViewController() is NewsViewController
        case 4:
            return UIApplication.topViewController() is NewsViewController
        case 5:
            //return UIApplication.topViewController() is MagazinesViewController
            return false
        case 6:
            return UIApplication.topViewController() is NewsViewController
        case 7:
            return UIApplication.topViewController() is NewsViewController
        case 8:
            //return UIApplication.topViewController() is NotificationsViewController
            return false
        default:
            return UIApplication.topViewController() is NewsViewController
        }
    }
}
