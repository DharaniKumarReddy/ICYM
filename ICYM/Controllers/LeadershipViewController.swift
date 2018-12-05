//
//  LeadershipViewController.swift
//  ICYM
//
//  Created by Dharani Reddy on 24/11/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit

class LeadershipViewController: UIViewController {

    // MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = false
        navigationBackWithNoText()
        title = "LEADERSHIP"
    }
    
    // MARK:- Private Methods
    private func loadController(isCouncil: Bool? = false, isNexco: Bool? = false) {
        let controller = UIStoryboard(name: Constant.StoryBoard.Main, bundle: Bundle.main).instantiateViewController(withIdentifier: String(describing: LeadershipNationalsViewController.self)) as! LeadershipNationalsViewController
        controller.isNexco = isNexco ?? false
        controller.isNationalCouncil = isCouncil ?? false
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK:- IBActions
    @IBAction private func directorButton_Tapped(button: UIButton) {
        let webUrl = [0 : "http://www.youthactiv8.com/icym_app/chairman.html", 1 : "http://www.youthactiv8.com/icym_app/memberbishop1.html", 2 : "http://www.youthactiv8.com/icym_app/memberbishop2.html", 3 : "http://www.youthactiv8.com/icym_app/ocd_nyd.html"][button.tag]
        pushWebPage(url: webUrl, title: "ICYM")
    }
    
    @IBAction private func governingBodyButton_Tapped(button: UIButton) {
        loadController(isNexco: button.tag != 0)
    }
    
    @IBAction private func nationalCouncilButton_Tapped() {
        loadController(isCouncil: true)
    }
    
    @IBAction private func aluminiButton_Tapped() {
        pushWebPage(url: "http://www.youthactiv8.com/icym_app/alumni.html", title: "ALUMINI")
    }
}
