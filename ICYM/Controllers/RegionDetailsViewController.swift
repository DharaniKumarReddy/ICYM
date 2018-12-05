//
//  RegionDetailsViewController.swift
//  ICYM
//
//  Created by Dharani Reddy on 22/11/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit

class RegionDetailsViewController: UIViewController {

    // MARK:- Variables
    internal var region: Region?
    
    // MARK:- IBOutlets
    @IBOutlet private weak var regionNameLabel: UILabel!
    @IBOutlet private weak var regionImageView: UIImageView!
    
    // MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        navigationBackWithNoText()
        title = region?.regionName.uppercased()
    }
    
    // MARK:- Private Methods
    private func loadData() {
        regionImageView.downloadImageFrom(link: region?.image ?? "", contentMode: .scaleAspectFill)
        regionNameLabel.text = region?.regionName
    }
    
    private func loadPhotoVideos(isPhotos: Bool) {
        let photoVideoController = UIStoryboard(name: Constant.StoryBoard.Main, bundle: Bundle.main).instantiateViewController(withIdentifier: String(describing: RegionPhotoVideoViewController.self)) as! RegionPhotoVideoViewController
        photoVideoController.isPhotos = isPhotos
        photoVideoController.regionId = Int(region?.id ?? "1")
        navigationController?.pushViewController(photoVideoController, animated: true)
    }
    
    private func getDioceses() -> String {
        if (region?.regionName ?? "").contains("Bihar") {
            return "http://youthactiv8.com/icym_app/diocese_bihar.html"
        } else if (region?.regionName ?? "").contains("Chattisgarh") {
            return "http://youthactiv8.com/icym_app/diocese_chhattisgarh.html"
        } else if (region?.regionName ?? "").contains("Jharkhand") {
            return "http://youthactiv8.com/icym_app/diocese_jharkhand.html"
        } else if (region?.regionName ?? "").contains("Karnataka") {
            return "http://youthactiv8.com/icym_app/diocese.html"
        } else if (region?.regionName ?? "").contains("Kerala") {
            return "http://youthactiv8.com/icym_app/diocese_kerala.html"
        } else if (region?.regionName ?? "").contains("Madhya Pradesh") {
            return "http://youthactiv8.com/icym_app/diocese_madhyapradesh.html"
        } else if (region?.regionName ?? "").contains("North east") {
            return "http://youthactiv8.com/icym_app/diocese_northeast.html"
        } else if (region?.regionName ?? "").contains("Northern") {
            return "http://youthactiv8.com/icym_app/diocese_northern.html"
        } else if (region?.regionName ?? "").contains("Odisha") {
            return "http://youthactiv8.com/icym_app/diocese_odisha.html"
        } else if (region?.regionName ?? "").contains("Tamilnadu") {
            return "http://youthactiv8.com/icym_app/diocese_tamilnadu.html"
        } else if (region?.regionName ?? "").contains("Telugu") {
            return "http://youthactiv8.com/icym_app/diocese_telugu.html"
        } else if (region?.regionName ?? "").contains("Uttar Pradesh") {
            return "http://youthactiv8.com/icym_app/diocese_uttarpradesh.html"
        } else if (region?.regionName ?? "").contains("West Bengal & Sikkim") {
            return "http://youthactiv8.com/icym_app/diocese_westbengal.html"
        } else if (region?.regionName ?? "").contains("Western") {
            return "http://youthactiv8.com/icym_app/diocese_western.html"
        }
        return ""
    }
    
    // MARK:- IBActions
    @IBAction private func regionalNewsButton_Tapped() {
        showNews(id: Int(region?.id ?? "1"))
    }
    
    @IBAction private func regionalAddressButton_Tapped() {
        let officeAddressController = UIStoryboard(name: Constant.StoryBoard.Main, bundle: Bundle.main).instantiateViewController(withIdentifier: String(describing: RegionOfficeAdressViewController.self)) as! RegionOfficeAdressViewController
        officeAddressController.regionId = Int(region?.id ?? "1")
        navigationController?.pushViewController(officeAddressController, animated: true)
    }
    
    @IBAction private func rexcoButton_Tapped() {
        showTableLoadedController(type: .Bearers, regionId: Int(region?.id ?? "1"))
    }
    
    @IBAction private func regionalCircularButton_Tapped() {
        showTableLoadedController(type: .Reports, regionId: Int(region?.id ?? "1"))
    }
    
    @IBAction private func photosButton_Tapped() {
        loadPhotoVideos(isPhotos: true)
    }
    
    @IBAction private func videosButton_Tapped() {
        loadPhotoVideos(isPhotos: false)
    }
    
    @IBAction private func diocesesButton_Tapped() {
        pushWebPage(url: getDioceses(), title: "ICYM")
    }
}
