//
//  Models.swift
//  ICYM
//
//  Created by Dharani Reddy on 14/11/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import Foundation

// MARK:- Dashboard
struct Photo {
    internal var id: String
    internal var img: String
    internal var date: Date
    internal var updatedDate: String
}

struct DashboardCover {
    internal var coverPhoto: [Photo]
    internal var success: Int
    internal var message: String
}

struct IcymNews {
    internal var news: [News]
    internal var success: Int
    internal var message: String
}

struct News {
    internal var id: String
    internal var regionID: String
    internal var image: String
    internal var title: String
    internal var newsDescription: String
    internal var newsDate: String
    internal var date: Date
    internal var updatedDate: String
}

struct AYSMagazines {
    internal var magazines: [AYSMagazine]
    internal var success: Int
    internal var message: String
}

struct AYSMagazine {
    internal var id: String
    internal var name: String
    internal var image: String
    internal var month: String
    internal var urlPdf: String
    internal var updatedDate: String
}

struct IcymRegions {
    internal var regions: [Region]
    internal var success: Int
    internal var message: String
}

struct Region {
    internal var id: String
    internal var regionName: String
    internal var image: String
    internal var updatedDate: String
}

struct OfficeBearers {
    internal var bearers: [Bearer]
    internal var success: Int
    internal var message: String
}

struct Bearer {
    internal var id: String
    internal var regionId: String
    internal var name: String
    internal var image: String
    internal var designation: String
    internal var diocese: String
    internal var email: String
    internal var updatedDate: String
}

struct AnnualReports {
    internal var reports: [AnnualReport]
    internal var success: Int
    internal var message: String
}

struct AnnualReport {
    internal var id: String
    internal var regionId: String
    internal var title: String
    internal var pdfLink: String
    internal var updatedDate: String
}

struct RegionalPhotos {
    internal var photos: [Photo]
    internal var success: Int
    internal var message: String
}

struct RegionalVideos {
    internal var videos: [Video]
    internal var success: Int
    internal var message: String
}

struct Video {
    internal var id: String
    internal var regionId: String
    internal var title: String
    internal var videoId: String
    internal var videoDate: String
    internal var videoDescription: String
    internal var updatedDate: String
}

struct IcymGoverningBody {
    internal var governingBodies: [Bearer]
    internal var success: Int
    internal var message: String
}

struct Notification {
    internal var id: String
    internal var title: String
    internal var date: String
    internal var description: String
    internal var updatedAt: String
}
