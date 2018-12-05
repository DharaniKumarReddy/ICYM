//
//  NYCViewController.swift
//  ICYM
//
//  Created by Dharani Reddy on 20/11/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit

class NYCViewController: UIViewController {

    // MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = false
        navigationBackWithNoText()
    }
    
    // MARK:- IBActions
    @IBAction private func prayerButton_Tapped() {
        pushWebPage(url: "http://www.youthactiv8.com/icym_app/nyc.html", title: "PRAYER AND MASS")
    }
    
    @IBAction private func themeButton_Tapped() {
        pushWebPage(url: "http://www.youthactiv8.com/icym_app/themesong.html", title: "THEME SONG")
    }
    
    @IBAction private func historyButton_Tapped() {
        pushWebPage(url: "http://www.youthactiv8.com/icym_app/history.html", title: "HISTORY OF NYC")
    }
    
    @IBAction private func newsEventsButton_Tapped() {
        showNews(isRegionsNews: false, id: nil)
    }
    
    @IBAction private func logoButton_Tapped() {
        pushWebPage(url: "http://www.youthactiv8.com/logo.html", title: "ICYM")
    }
    
    @IBAction private func sessionsButton_Tapped() {
        pushWebPage(url: "http://www.youthactiv8.com/icym_app/layoutmap.html", title: "SESSIONS")
    }
    
    @IBAction private func youthActiveButton_Tapped() {
        pushWebPage(url: "http://www.youthactiv8.com", title: "YOUTH ACTIVES")
    }
    
    @IBAction private func galleryButton_Tapped() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let photoAction = UIAlertAction(title: "Photos", style: .default) { action in
            self.pushWebPage(url: "http://youthactiv8.com/icym_app/gallery.html", title: "PHOTOS")
        }
        actionSheet.addAction(photoAction)
        let videoAction = UIAlertAction(title: "Videos", style: .default) { action in
            self.pushWebPage(url: "http://www.youthactiv8.com/icym_app/whowill.html", title: "VIDEOS")
        }
        actionSheet.addAction(videoAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
            
        })
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction private func feedbackButton_Tapped() {
        pushWebPage(url: "http://www.youthactiv8.com/icym_app/feedback.php", title: "FEEDBACK")
    }
}
