//
//  UIViewControllerExtension.swift
//  ICYM
//
//  Created by Dharani Reddy on 17/11/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func navigationBackWithNoText() {
        let barButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(popViewController))
        barButton.image = UIImage(named: "UINavigationBarBackIndicatorDefault")
        barButton.tintColor = UIColor(red: 0, green: 82/255, blue: 138/255, alpha: 1.0)
        navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func popViewController() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    private func getWebController() -> WebViewController {
        return UIStoryboard(name: Constant.StoryBoard.Main, bundle: Bundle.main).instantiateViewController(withIdentifier: String(describing: WebViewController.self)) as! WebViewController
    }
    
    func pushWebPage(url: String?, title: String) {
        slideMenuController()?.closeLeft()
        let webViewController = getWebController()
        webViewController.webUrlString = url
        webViewController.title = title
        (slideMenuController()?.mainViewController as! UINavigationController).pushViewController(webViewController, animated: true)
    }
    
    func presentWebPage(url: String?) {
        let webViewController = getWebController()
        webViewController.webUrlString = url
        present(webViewController, animated: true, completion: nil)
    }
    
    func showNews(isRegionsNews: Bool = true, id: Int?) {
        let newsController = UIStoryboard(name: Constant.StoryBoard.Main, bundle: Bundle.main).instantiateViewController(withIdentifier: String(describing: NewsViewController.self)) as! NewsViewController
        newsController.regionNews = isRegionsNews
        newsController.regionId = id
        navigationController?.pushViewController(newsController, animated: true)
    }
    
    func showTableLoadedController(type: TableType, regionId: Int?) {
        let officeBearerController = UIStoryboard(name: Constant.StoryBoard.Main, bundle: Bundle.main).instantiateViewController(withIdentifier: String(describing: AYSMagazinesViewController.self)) as! AYSMagazinesViewController
        officeBearerController.configure(tableType: type, regionId: regionId)
        navigationController?.pushViewController(officeBearerController, animated: true)
    }
    
    func showAlertViewController(_ title: String, message: String, cancelButton: String, destructiveButton: String!, otherButtons:String!, onDestroyAction: @escaping OnDestroySuccess, onCancelAction: @escaping OnCancelSuccess) {
        
        let alertController = UIAlertController(title: NSLocalizedString(title, comment: ""), message: NSLocalizedString(message, comment: ""), preferredStyle: .alert)
        let cancelAction    = UIAlertAction(title: NSLocalizedString(cancelButton, comment: ""), style: .cancel) { alertAction in
            onCancelAction()
        }
        alertController.addAction(cancelAction)
        
        var alertAction:UIAlertAction!
        
        if let nonDestructiveButton = otherButtons {
            alertAction = UIAlertAction(title: nonDestructiveButton, style: .default) { alertAction in
                onDestroyAction()
            }
            alertController.addAction(alertAction)
        } else if let destructiveButton = destructiveButton {
            // Apple says when most likely button is destructive it should be on the left
            alertAction = UIAlertAction(title: NSLocalizedString(destructiveButton, comment: ""), style: .destructive) { alertAction in
                onDestroyAction()
            }
            alertController.addAction(alertAction)
        }
        
        if let topViewController = UIApplication.topViewController() {
            topViewController.present(alertController, animated: true)
        }
    }
}
