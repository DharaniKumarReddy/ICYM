//
//  Parser.swift
//  ICYM
//
//  Created by Dharani Reddy on 14/11/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class Parser {
    static let sharedInstance = Parser()
    private init() {}
    
    internal func parseDashboardCoverPhotos(jsonString: String, onSuccess: (DashboardCover?)->(Void)) {
        if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
            let json = try? JSON(data: dataFromString)
            let success = json?["success"].intValue ?? 0
            let message = json?["message"].stringValue ?? ""
            let photos = json?["coverphoto"].arrayValue
            var coverPhotosArray: [Photo] = []
            for photo in photos ?? [] {
                let id = photo["id"].stringValue
                let image = photo["img"].stringValue
                let updatedDate = photo["updated_date"].stringValue
                let date = DateFormatters.defaultDateFormatter().date(from: updatedDate) ?? Date()
                let photo = Photo(id: id, img: image, date: date, updatedDate: updatedDate)
                coverPhotosArray.append(photo)
            }
            onSuccess(DashboardCover(coverPhoto: coverPhotosArray, success: success, message: message))
        }
    }
    
    internal func parseNews(jsonString: String, onSuccess: (IcymNews?)->(Void)) {
        if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
            let json = try? JSON(data: dataFromString)
            let success = json?["success"].intValue ?? 0
            let message = json?["message"].stringValue ?? ""
            let news = json?["icym_news"].arrayValue
            onSuccess(IcymNews(news: getNews(news: news, imageKey: "l_img"), success: success, message: message))
        }
    }
    
    internal func parseNewsImages(jsonString: String, onSuccess: (IcymNews?)->(Void)) {
        if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
            let json = try? JSON(data: dataFromString)
            let success = json?["success"].intValue ?? 0
            let message = json?["message"].stringValue ?? ""
            let newsImages = json?["newsimages"].arrayValue
            var newsImagesArray: [News] = []
            for newsImage in newsImages ?? [] {
                let id = newsImage["id"].stringValue
                let image = newsImage["img"].stringValue
                let newsObject = News(id: id, regionID: "", image: image, title: "", newsDescription: "", newsDate: "", date: Date(), updatedDate: "")
                newsImagesArray.append(newsObject)
            }
            onSuccess(IcymNews(news: newsImagesArray, success: success, message: message))
        }
    }
    
    internal func parseNYCNews(jsonString: String, onSuccess: (IcymNews?)->(Void)) {
        if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
            let json = try? JSON(data: dataFromString)
            let success = json?["success"].intValue ?? 0
            let message = json?["message"].stringValue ?? ""
            let news = json?["nycnews"].arrayValue
            onSuccess(IcymNews(news: getNews(news: news, imageKey: "limg"), success: success, message: message))
        }
    }
    
    private func getNews(news: [JSON]?, imageKey: String) -> [News] {
        var newsArray: [News] = []
        for newsObject in news ?? [] {
            let id = newsObject["id"].stringValue
            let regionId = newsObject["region_id"].stringValue
            let image = newsObject[imageKey].stringValue
            let title = newsObject["title"].stringValue
            let updatedAt = newsObject["updated_at"].stringValue
            let description = newsObject["description"].stringValue
            let newsDate = newsObject["date"].stringValue
            let date = DateFormatters.defaultDateFormatter().date(from: updatedAt) ?? Date()
            let news = News(id: id, regionID: regionId, image: image, title: title, newsDescription: description, newsDate: newsDate, date: date, updatedDate: updatedAt)
            newsArray.append(news)
        }
        return newsArray
    }
    
    internal func parseAYSMagazine(jsonString: String, onSuccess: (AYSMagazines?)->(Void)) {
        if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
            let json = try? JSON(data: dataFromString)
            let success = json?["success"].intValue ?? 0
            let message = json?["message"].stringValue ?? ""
            let magazines = json?["magazine"].arrayValue
            var magazinesArray: [AYSMagazine] = []
            for magazine in magazines ?? [] {
                let id = magazine["id"].stringValue
                let name = magazine["name"].stringValue
                let image = magazine["img"].stringValue
                let month = magazine["month"].stringValue
                let pdfUrl = magazine["urlpdf"].stringValue
                let updatedAt = magazine["updated_at"].stringValue
                let magazineObject = AYSMagazine(id: id, name: name, image: image, month: month, urlPdf: pdfUrl, updatedDate: updatedAt)
                magazinesArray.append(magazineObject)
            }
            onSuccess(AYSMagazines(magazines: magazinesArray, success: success, message: message))
        }
    }
    
    internal func parseRegionsList(jsonString: String, onSuccess: (IcymRegions?)->(Void)) {
        if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
            let json = try? JSON(data: dataFromString)
            let success = json?["success"].intValue ?? 0
            let message = json?["message"].stringValue ?? ""
            let regions = json?["regionslist"].arrayValue
            var regionsArray: [Region] = []
            for region in regions ?? [] {
                let id = region["id"].stringValue
                let name = region["regions"].stringValue
                let img = region["img"].stringValue
                let updatedAt = region["updated_at"].stringValue
                let regionsObject = Region(id: id, regionName: name, image: img, updatedDate: updatedAt)
                regionsArray.append(regionsObject)
            }
            onSuccess(IcymRegions(regions: regionsArray, success: success, message: message))
        }
    }
    
    internal func parseOfficeAddress(jsonString: String, onSuccess: (String?)-> (Void)) {
        if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
            let json = try? JSON(data: dataFromString)
            let addressObject = json?["regionoffice"].arrayValue.first
            onSuccess(addressObject?["address"].stringValue)
        }
    }
    
    internal func parseOfficeBearers(jsonString: String, onSuccess: (OfficeBearers?)-> (Void)) {
        if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
            let json = try? JSON(data: dataFromString)
            let success = json?["success"].intValue ?? 0
            let message = json?["message"].stringValue ?? ""
            let bearers = json?["office_bearers"].arrayValue
//            var bearersArray: [Bearer] = []
//            for bearer in bearers ?? [] {
//                let id = bearer["id"].stringValue
//                let regionId = bearer["region_id"].stringValue
//                let name = bearer["name"].stringValue
//                let img = bearer["img"].stringValue
//                let designation = bearer["designation"].stringValue
//                let diocese = bearer["diocese"].stringValue
//                let email = bearer["email"].stringValue
//                let updatedAt = bearer["updated_at"].stringValue
//                let bearerObject = Bearer(id: id, regionId: regionId, name: name, image: img, designation: designation, diocese: diocese, email: email, updatedDate: updatedAt)
//                bearersArray.append(bearerObject)
//            }
            onSuccess(OfficeBearers(bearers: getBearers(bearers: bearers), success: success, message: message))
        }
    }
    
    private func getBearers(bearers: [JSON]?) -> [Bearer] {
        var bearersArray: [Bearer] = []
        for bearer in bearers ?? [] {
            let id = bearer["id"].stringValue
            let regionId = bearer["region_id"].stringValue
            let name = bearer["name"].stringValue
            let img = bearer["img"].stringValue
            let designation = bearer["designation"].stringValue
            let diocese = bearer["diocese"].stringValue
            let email = bearer["email"].stringValue
            let updatedAt = bearer["updated_at"].stringValue
            let bearerObject = Bearer(id: id, regionId: regionId, name: name, image: img, designation: designation, diocese: diocese, email: email, updatedDate: updatedAt)
            bearersArray.append(bearerObject)
        }
        return bearersArray
    }
    
    internal func parseAnnualReports(jsonString: String, onSuccess: (AnnualReports?)-> (Void)) {
        if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
            let json = try? JSON(data: dataFromString)
            let success = json?["success"].intValue ?? 0
            let message = json?["message"].stringValue ?? ""
            let reports = json?["annualreport"].arrayValue
            var reportsArray: [AnnualReport] = []
            for report in reports ?? [] {
                let id = report["id"].stringValue
                let regionId = report["region_id"].stringValue
                let title = report["title"].stringValue
                let pdfLink = report["pdf_link"].stringValue
                let updatedAt = report["updated_at"].stringValue
                let reportObject = AnnualReport(id: id, regionId: regionId, title: title, pdfLink: pdfLink, updatedDate: updatedAt)
                reportsArray.append(reportObject)
            }
            onSuccess(AnnualReports(reports: reportsArray, success: success, message: message))
        }
    }
    
    internal func parseRegionalPhotos(jsonString: String, onSuccess: (RegionalPhotos?)-> (Void)) {
        if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
            let json = try? JSON(data: dataFromString)
            let success = json?["success"].intValue ?? 0
            let message = json?["message"].stringValue ?? ""
            let photos = json?["photograph"].arrayValue
            var photosArray: [Photo] = []
            for photo in photos ?? [] {
                let id = photo["id"].stringValue
                let image = photo["img"].stringValue
                let createdAt = photo["created_at"].stringValue
                let photoObject = Photo(id: id, img: image, date: Date(), updatedDate: createdAt)
                photosArray.append(photoObject)
            }
            onSuccess(RegionalPhotos(photos: photosArray, success: success, message: message))
        }
    }
    
    internal func parseRegionalVideos(arrayKey: String, jsonString: String, onSuccess: (RegionalVideos?)-> (Void)) {
        if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
            let json = try? JSON(data: dataFromString)
            let success = json?["success"].intValue ?? 0
            let message = json?["message"].stringValue ?? ""
            let videos = json?[arrayKey].arrayValue
            var videosArray: [Video] = []
            for video in videos ?? [] {
                let id = video["id"].stringValue
                let regionId = video["region_id"].stringValue
                let title = video["v_title"].stringValue
                let videoId = video["v_id"].stringValue
                let videoDate = video["v_date"].stringValue
                let description = video["v_description"].stringValue
                let updatedAt = video["updated_at"].stringValue
                let videoObject = Video(id: id, regionId: regionId, title: title, videoId: videoId, videoDate: videoDate, videoDescription: description, updatedDate: updatedAt)
                videosArray.append(videoObject)
            }
            onSuccess(RegionalVideos(videos: videosArray, success: success, message: message))
        }
    }
    
    internal func parseGoverningBodies(arrayKey: String, jsonString: String, onSuccess: (IcymGoverningBody?)-> (Void)) {
        if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
            let json = try? JSON(data: dataFromString)
            let success = json?["success"].intValue ?? 0
            let message = json?["message"].stringValue ?? ""
            let bodies = json?[arrayKey].arrayValue
            onSuccess(IcymGoverningBody(governingBodies: getBearers(bearers: bodies), success: success, message: message))
        }
    }
    
    internal func parseNotifications(jsonString: String, onSuccess: ([Notification])-> (Void)) {
        if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
            let json = try? JSON(data: dataFromString)
            let notifications = json?["notification"].arrayValue
            var notificationsArray: [Notification] = []
            for notification in notifications ?? [] {
                let id = notification["id"].stringValue
                let title = notification["title"].stringValue
                let date = notification["date"].stringValue
                let description = notification["description"].stringValue
                let updatedAt = notification["updated_at"].stringValue
                let notificationObject = Notification(id: id, title: title, date: date, description: description, updatedAt: updatedAt)
                notificationsArray.append(notificationObject)
            }
            onSuccess(notificationsArray)
        }
    }
}
