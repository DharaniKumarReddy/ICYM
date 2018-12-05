//
//  RegionalOfficeAdressViewController.swift
//  ICYM
//
//  Created by Dharani Reddy on 23/11/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit

class RegionOfficeAdressViewController: UIViewController {

    // MARK:- Variables
    internal var regionId: Int?
    
    // MARK:- IBOutlets
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        getAddress()
        navigationBackWithNoText()
        title = "OFFICE ADDRESS"
    }
    
    // MARK:- Private Methods
    private func getAddress() {
        APICaller.getInstance().getRegionalOfficeAddress(regionID: regionId ?? 1, onSuccess: { address in
            if let attributedDescripition = Helper.richHtmlAttributeConversion(content: address ?? "", fontName: "Hoefler Text", fontSize: 16, hexColor: "#414124") {
                self.textView.attributedText = attributedDescripition
            }
            self.activityIndicator.stopAnimating()
        }, onError: { _ in
            
        })
        APICaller.getInstance().getRegionalAnnualReport(regionID: regionId ?? 1, onSuccess: { _ in}, onError: { _ in})
    }
}
