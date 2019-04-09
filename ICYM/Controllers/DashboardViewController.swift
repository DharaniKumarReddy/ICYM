//
//  DashboardViewController.swift
//  ICYM
//
//  Created by Dharani Reddy on 07/11/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

let screenWidth     = UIScreen.main.bounds.width
let screenHeight    = UIScreen.main.bounds.height

class DashboardViewController: UIViewController {
    
    // MARK:- Private Variables
    private let moreMenuVariables = ["NYC", "AYD", "WYD", "APNA YUVA SPANDAN", "REGIONS IN INDIA", "LEADERSHIP", "ANIMATIONS", "CAP INDIA", "MEMORANDUM", "NOTIFICATION", "FACEBOOK", "TWITTER"]
    
    private var coverPhotos: [Photo] = []
    
    private var isNotifiedAlertDismissed = true
    
    // MARK:- IBOutlets
    @IBOutlet private weak var websitesView: UIView!
    @IBOutlet private weak var slidingImageView: UIImageView!
    @IBOutlet private weak var bottomViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var websitesViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var websitesViewHeightConstraint: NSLayoutConstraint!

    // MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomViewTopConstraint.constant = screenHeight
        websitesViewWidthConstraint.constant = 80
        websitesViewHeightConstraint.constant = 0
        slideMenuController()?.changeLeftViewWidth(screenWidth-screenWidth/5)
        SlideMenuOptions.contentViewScale = 1.0
        getDashboardCoverPhotos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK:- Private Methods
    private func animateBottomView(constant: CGFloat) {
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomViewTopConstraint.constant = constant
            self.view.layoutIfNeeded()
        })
    }
    
    private func getDashboardCoverPhotos() {
        APICaller.getInstance().getDashboardCoverPhotos(onSuccess: { dashboardCover in
            self.coverPhotos = dashboardCover?.coverPhoto ?? []
            self.coverPhotos.sort{ $0.date.compare($1.date) == .orderedDescending }
            self.downloadImages()
            }) {_ in
        
        }
    }
    
    private func downloadImages() {
        var coverPhoto: [UIImage] = []
        for photo in coverPhotos {
            photo.img.downloadImage(completion: { image in
                coverPhoto.append(image)
                if coverPhoto.count == self.coverPhotos.count {
                    DispatchQueue.main.async {
                        self.animateImageSlides(images: coverPhoto)
                    }
                }
            })
        }
    }
    
    private func animateImageSlides(images: [UIImage]) {
        slidingImageView.animationImages = images
        slidingImageView.animationDuration = TimeInterval(images.count * 2)
//        slidingImageView.animationRepeatCount = 1
        
        slidingImageView.startAnimating()
    }
    
    private func animateWebsitesView(width: CGFloat, height: CGFloat) {
        UIView.animate(withDuration: 0.3, animations: {
            self.websitesViewWidthConstraint.constant = width
            self.websitesViewHeightConstraint.constant = height
            self.websitesView.alpha = height == 0 ? 0 : 0.5
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.websitesView.alpha = height == 0 ? 0 : 1
        })
    }
    
    private func animations() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let photoAction = UIAlertAction(title: "ACTION SONGS", style: .default) { action in
            let actionSongsController = UIStoryboard(name: Constant.StoryBoard.Main, bundle: Bundle.main).instantiateViewController(withIdentifier: String(describing: ActionSongsViewController.self)) as! ActionSongsViewController
            self.navigationController?.pushViewController(actionSongsController, animated: true)
        }
        actionSheet.addAction(photoAction)
        let videoAction = UIAlertAction(title: "ICE BREAKERS", style: .default) { action in
            self.pushWebPage(url: "http://www.youthactiv8.com/icym_app/gamesearch.php", title: "ICE BREAKERS")
        }
        actionSheet.addAction(videoAction)
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: {_ in
            
        })
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true, completion: nil)
    }
    
    // MARK:- IBActions
    @IBAction private func moreButton_Tapped() {
        animateBottomView(constant: 0)
    }
    
    @IBAction private func closeButton_Tapped() {
        animateBottomView(constant: screenHeight)
    }
    
    @IBAction private func websitesButton_Tapped() {
        animateWebsitesView(width: screenWidth, height: screenHeight)
    }
    
    @IBAction private func websitesCloseButton_Tapped() {
        animateWebsitesView(width: 80, height: 0)
    }
    
    @IBAction private func aboutUsButton_Tapped() {
        presentWebPage(url: nil)
    }
    
    @IBAction private func prayerButton_Tapped() {
        pushWebPage(url: "http://youthactiv8.com/icym_app/devotion_collection.html", title: "Prayer")
    }
    
    @IBAction private func websiteViewButton_Tapped(button: UIButton) {
        let websiteUrl = ["http://w2.vatican.va/content/vatican/it.html", "http://www.fabc.org/", "http://www.cbci.in/", "http://ccbi.in/", "http://www.catholicate.net/", "http://www.syromalabarchurch.in/index.php", "http://www.youthactiv8.com/", "http://www.icym.net/"][button.tag]
        pushWebPage(url: websiteUrl, title: "ICYM")
    }
}

extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moreMenuVariables.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MoreMenuTableCell.self)) as? MoreMenuTableCell
        cell?.titleLabel.text = moreMenuVariables[indexPath.row]
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let nycController = UIStoryboard(name: Constant.StoryBoard.Main, bundle: Bundle.main).instantiateViewController(withIdentifier: String(describing: NYCViewController.self)) as! NYCViewController
            navigationController?.pushViewController(nycController, animated: true)
        case 1:
            pushWebPage(url: "http://youthactiv8.com/icym_app/ayd_17.html", title: "AYD")
        case 2:
            pushWebPage(url: "http://youthactiv8.com/wyd/home.html", title: "WYD")
        case 3:
            showTableLoadedController(type: .Magazines, regionId: nil)
        case 4:
            let regionsController = UIStoryboard(name: Constant.StoryBoard.Main, bundle: Bundle.main).instantiateViewController(withIdentifier: String(describing: RegionsViewController.self)) as! RegionsViewController
            navigationController?.pushViewController(regionsController, animated: true)
        case 5:
            let leadershipController = UIStoryboard(name: Constant.StoryBoard.Main, bundle: Bundle.main).instantiateViewController(withIdentifier: String(describing: LeadershipViewController.self)) as! LeadershipViewController
            navigationController?.pushViewController(leadershipController, animated: true)
        case 6:
            animations()
        case 7:
            pushWebPage(url: "http://capindia.co/", title: "CAP INDIA")
        case 8:
            pushWebPage(url: "http://youthactiv8.com/pdf/memorandum.pdf", title: "MEMORANDUM")
        case 9:
            let controller = UIStoryboard(name: Constant.StoryBoard.Main, bundle: Bundle.main).instantiateViewController(withIdentifier: String(describing: NotificationViewController.self)) as! NotificationViewController
            navigationController?.pushViewController(controller, animated: true)
        case 10:
            pushWebPage(url: "https://www.facebook.com/icymindia", title: "FACEBOOK")
        case 11:
            pushWebPage(url: "https://twitter.com/IcymIndia", title: "TWITTER")
        default:
            break
        }
    }
}

class MoreMenuTableCell: UITableViewCell {
    @IBOutlet internal weak var titleLabel: UILabel!
}

extension DashboardViewController {
    /**
     Before notification going to invoke its controller, basic checks needs to be verified and notificaton will be fired.
     */
    internal func postRemoteNotification() {
        
        // Check Notification is recieved while app is foreground
        if PushNotificationHandler.sharedInstance.isNotificationRecievedInForeground && isNotifiedAlertDismissed {
            PushNotificationHandler.sharedInstance.isNotificationRecievedInForeground = false
            self.isNotifiedAlertDismissed = false
            // Pop's up the alertview and notifiy user to whether he/she wants to reach notified controller
            guard TopViewController.isNotifiedController() else {
                showAlertViewController("", message: truncateCharactersInNotificationMessage(PushNotificationHandler.sharedInstance.notificationMessage as NSString), cancelButton: "Close", destructiveButton: "", otherButtons: "Open", onDestroyAction: {
                    self.isNotifiedAlertDismissed = true
                    PushNotificationHandler.sharedInstance.isNotificationReachedItsDestination = true
                    self.presentNotifiedViewController()
                }, onCancelAction: {
                    self.isNotifiedAlertDismissed = true
                    // Making sure app is reached its destination view controller, so that future notifications will show
                    PushNotificationHandler.sharedInstance.isNotificationReachedItsDestination = true
                })
                return
            }
            isNotifiedAlertDismissed = true
            PushNotificationHandler.sharedInstance.isNotificationReachedItsDestination = true
        } else if isNotifiedAlertDismissed {
            
            //Looks for destined notification controller
            presentNotifiedViewController()
        } else {
            // Making sure app is reached its destination view controller, so that future notifications will show
            PushNotificationHandler.sharedInstance.isNotificationReachedItsDestination = true
        }
    }
    /**
     To confirm whether notification reached its destined controller.
     */
    private func isNotificationYetToReachItsDestination() {
        if PushNotificationHandler.sharedInstance.isPushNotificationRecieved {
            postRemoteNotification()
        }
    }
    
    internal func presentNotifiedViewController() {
        
        print(PushNotificationHandler.sharedInstance.notificationType)
        PushNotificationHandler.sharedInstance.isPushNotificationRecieved = false
        let type = PushNotificationHandler.sharedInstance.notificationType
        switch type {
        case 1:
            showNews(isRegionsNews: true, id: PushNotificationHandler.sharedInstance.regionId)
        case 3:
            showNews(isRegionsNews: false, id: nil)
        case 4:
            showTableLoadedController(type: .Magazines, regionId: nil)
        case 5:
            let controller = UIStoryboard(name: Constant.StoryBoard.Main, bundle: Bundle.main).instantiateViewController(withIdentifier: String(describing: NotificationViewController.self)) as! NotificationViewController
            navigationController?.pushViewController(controller, animated: true)
        default:
            break
        }
    }
}
