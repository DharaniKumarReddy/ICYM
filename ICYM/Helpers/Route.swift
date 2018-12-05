//
//  Route.swift
//  ICYM
//
//  Created by Dharani Reddy on 14/11/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import Foundation

let Base_Url = "http://youthactiv8.com"

enum Route {
    case coverPhoto
    case news
    case newsMultipleImages
    case nycNews
    case aysMagazine
    case regions
    case officeAddress
    case officeBearers
    case annualReport
    case regionPhotos
    case regionVideos
    case governingBody
    case nexco
    case nationalCouncil
    case notification
    case animationSongs
    
    var absoluteURL: URL {
        return URL(string: Base_Url + apiPath)!
    }
    
    private var apiPath: String {
        switch self {
        case .coverPhoto:
            return "/icym_app/icym_coverphoto.php"
        case .news:
            return "/icym_app/icym_news.php"
        case .newsMultipleImages:
            return "/icym_app/icym_newsimages.php"
        case .nycNews:
            return "/icym_app/icym_nycnews.php"
        case .aysMagazine:
            return "/icym_app/magazine.php"
        case .regions:
            return "/icym_app/icym_main.php"
        case .officeAddress:
            return "/icym_app/region_office.php"
        case .officeBearers:
            return "/icym_app/icym_bearers.php"
        case .annualReport:
            return "/icym_app/icym_annualreport.php"
        case .regionPhotos:
            return "/icym_app/icym_photograph.php"
        case .regionVideos:
            return "/icym_app/icym_videos.php"
        case .governingBody:
            return "/icym_app/governing.php"
        case .nationalCouncil:
            return "/icym_app/icym_national.php"
        case .nexco:
            return "/icym_app/nexco.php"
        case .notification:
            return "/icym_app/icym_notification.php"
        case .animationSongs:
            return "/icym_app/icym_videos1.php"
        }
    }
}
