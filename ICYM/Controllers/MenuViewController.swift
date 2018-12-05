//
//  MenuViewController.swift
//  ICYM
//
//  Created by Dharani Reddy on 07/11/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction private func aboutUsButton_Tapped() {
        pushWebPage(url: "http://youthactiv8.com/icym_app/about.html", title: "ICYM")
    }
    
    @IBAction private func leadershipButton_Tapped() {
        slideMenuController()?.closeLeft()
        let leadershipController = UIStoryboard(name: Constant.StoryBoard.Main, bundle: Bundle.main).instantiateViewController(withIdentifier: String(describing: LeadershipViewController.self)) as! LeadershipViewController
        (slideMenuController()?.mainViewController as! UINavigationController).pushViewController(leadershipController, animated: true)
    }
    
    @IBAction private func capIndiaButton_Tapped() {
        pushWebPage(url: "http://capindia.co/", title: "CAP INDIA")
    }
    
    @IBAction private func websitesButton_Tapped() {
        pushWebPage(url: "http://www.youthactiv8.com/", title: "ICYM")
    }
    
    @IBAction private func getInTouchButton_Tapped() {
        let controller = UIAlertController(title: "", message: "ICYM/YAF HOME 3026/5 A IST FLOOR NEAR HANUMAN CHOWK, SOUTH RANJEET NAGAR SOUTH PATEL NAGAR, NEW DELHI, 110 008", preferredStyle: .alert)
        let callAction = UIAlertAction(title: "CALL", style: .default, handler: { _ in
            
        })
        let emailAction = UIAlertAction(title: "EMAIL", style: .default, handler: { _ in
            
        })
        let goToMapAction = UIAlertAction(title: "GO TO MAP", style: .default, handler: { _ in
            
        })
        controller.addAction(callAction)
        controller.addAction(emailAction)
        controller.addAction(goToMapAction)
        present(controller, animated: true, completion: nil)
    }
}
