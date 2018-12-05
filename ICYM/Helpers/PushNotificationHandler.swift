//
//  PushNotificationHandler.swift
//  AlwaysOn
//
//  Created by Muralitharan on 14/07/15.
//  Copyright (c) 2015 Onlife Health. All rights reserved.
//

import Foundation

class PushNotificationHandler : NSObject {
    
    static let sharedInstance = PushNotificationHandler()
    
    var isNotificationRecievedInForeground: Bool = false
    
    var isLanchedByNotification: Bool = false
    
    var isPushNotificationRecieved: Bool = false
    
    var notificationMessage: String = ""
    
    var notificationType: Int = 0
    
    var regionId: Int = 0
    
    var isNotificationReachedItsDestination: Bool = true
}
