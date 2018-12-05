//
//  AppDelegate.swift
//  ICYM
//
//  Created by Dharani Reddy on 07/11/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit
import UserNotifications
import SlideMenuControllerSwift
import Firebase

typealias OnCompletion = ((Bool)->Void)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    internal var dashboard: DashboardViewController?
    
    var window: UIWindow?

    private var didRecieveNotificationTime:Date!
    private var payload:[AnyHashable: Any]!
    private var isNotificationFired = false
    
    private let mainViewController = UIStoryboard(name: Constant.StoryBoard.Main, bundle: Bundle.main).instantiateInitialViewController() as! UINavigationController
    
    private let menuViewController = UIStoryboard(name: Constant.StoryBoard.Main, bundle: Bundle.main).instantiateViewController(withIdentifier: String(describing: MenuViewController.self))
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let slideMenuViewController = SlideMenuController(mainViewController: mainViewController, leftMenuViewController: menuViewController)
        window?.rootViewController = slideMenuViewController
        window?.makeKeyAndVisible()
        // To verify if the app is invoked by notifications
        if let remoteNotification = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? NSDictionary {
            //PushNotificationHandler.sharedInstance.isLanchedByNotification = true
            processNotification(remoteNotification as! [AnyHashable: Any] )
        }
        //UINavigationBar.appearance().barStyle = UIBarStyle.blackOpaque
        
        registerForPushNotifications()
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().subscribe(toTopic: "icym")
        return true
    }
    
    func registerForPushNotifications() {
        let isNotificationAlertShown =  UserDefaults.standard.bool(forKey: Constant.UserDefaults.isPushNotificationAlertTriggered)
        if !isNotificationAlertShown {
            let application = UIApplication.shared
            if #available(iOS 10.0, *) {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                    (granted, error) in
                    print("Permission granted: \(granted)")
                    if granted {
                        DispatchQueue.main.async {
                            application.registerForRemoteNotifications()
                        }
                    }
                }
            } else {
                let settings  = UIUserNotificationSettings(types: [UIUserNotificationType.alert , UIUserNotificationType.badge , UIUserNotificationType.sound], categories: nil)
                UIApplication.shared.registerUserNotificationSettings(settings)
                application.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = String(format: "%@", deviceToken as CVarArg)
            .trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
            .replacingOccurrences(of: " ", with: "")
        // Persist the device token to further retrevial.
        UserDefaults.standard.set(deviceTokenString, forKey: Constant.UserDefaults.deviceToken)
        UserDefaults.standard.synchronize()
        Messaging.messaging().apnsToken = deviceToken as Data
        print("DEVICE TOKEN = \(deviceTokenString)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        handleNotification(userInfo: userInfo){
            (_)  in
            completionHandler(UIBackgroundFetchResult.noData)
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func handleNotification(userInfo: [AnyHashable: Any], onCompletion: @escaping OnCompletion) {
        print(userInfo)
        if (userInfo["aps"] as? Dictionary<String, AnyObject>) != nil {
            didRecieveNotificationTime = Date()
            isNotificationFired = true
            payload = userInfo
            if UIApplication.shared.applicationState == .active {
                processNotification(userInfo)
            }
            onCompletion(true)
        }
    }
    
    /**
     Iterating APNS payload to find out the type of the notification.
     Category key in the payload determines the type of notification received.
     */
    
    func processNotification(_ userInfo: [AnyHashable: Any]) {
        
        guard PushNotificationHandler.sharedInstance.isNotificationReachedItsDestination else {
            return
        }
        
        PushNotificationHandler.sharedInstance.isPushNotificationRecieved = true
        PushNotificationHandler.sharedInstance.isNotificationRecievedInForeground = UIApplication.shared.applicationState == .active
        if let info = userInfo["aps"] as? Dictionary<String, AnyObject> {
            for (key, value) in info {
                if key == "alert" {
                    PushNotificationHandler.sharedInstance.notificationMessage = info["alert"]?["title"] as? String ?? ""
                    PushNotificationHandler.sharedInstance.notificationType = value as? Int ?? 0
                }
            }
        }
        if let type = userInfo["gcm.notification.type"] as? String {
            PushNotificationHandler.sharedInstance.notificationType = Int(type) ?? 1
        }
        if let type = userInfo["gcm.notification.region_id"] as? String {
            PushNotificationHandler.sharedInstance.regionId = Int(type) ?? 1
        }
        if let _ = dashboard {
            dashboard?.postRemoteNotification()
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print(fcmToken)
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print(messaging)
    }
}
