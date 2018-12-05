//
//  APICaller.swift
//  ICYM
//
//  Created by Dharani Reddy on 14/11/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import Foundation

typealias OnSuccessResponse = (String) -> Void
typealias OnDestroySuccess = () -> Void
typealias OnCancelSuccess = () -> Void
typealias OnErrorMessage = (String) -> Void

typealias JSONDictionary = [String : AnyObject]

private enum RequestMethod: String, CustomStringConvertible {
    case GET = "GET"
    case PUT = "PUT"
    case POST = "POST"
    case DELETE = "DELETE"
    case PATCH  = "PATCH"
    
    var description: String {
        return rawValue
    }
}

class APICaller {
    let MAX_RETRIES = 2
    
    fileprivate var urlSession: URLSession
    
    class func getInstance() -> APICaller {
        struct Static {
            static let instance = APICaller()
        }
        return Static.instance
    }
    
    fileprivate init() {
        urlSession = APICaller.createURLSession()
    }
    
    fileprivate class func createURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.urlCache = nil
        configuration.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        //        configuration.httpAdditionalHeaders = [
        //            "Accept"       : "application/json",
        //        ]
        
        return URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
    }
    
    fileprivate func resetURLSession() {
        urlSession.invalidateAndCancel()
        urlSession = APICaller.createURLSession()
    }
    
    fileprivate func createRequest(_ requestMethod: RequestMethod, _ route: Route, params: JSONDictionary? = nil, sectionName: String? = nil) -> URLRequest {
        let request = NSMutableURLRequest(url: route.absoluteURL as URL)
        request.httpMethod = requestMethod.rawValue
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        if let params = params {
            switch requestMethod {
            case .GET, .DELETE:
                var queryItems: [URLQueryItem] = []
                
                for (key, value) in params {
                    queryItems.append(URLQueryItem(name: "\(key)", value: "\(value)"))
                }
                
                if queryItems.count > 0 {
                    var components = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)
                    components?.queryItems = queryItems
                    request.url = components?.url
                }
                
            case .POST, .PUT, .PATCH:
                var bodyParams = ""
                for (key, value) in params {
                    bodyParams += "\(key)=" + "\(value)"
                }
                let postData = bodyParams.data(using: String.Encoding.ascii, allowLossyConversion: true)!
                //let body = try JSONSerialization.data(withJSONObject: params, options: [])
                request.httpBody = postData
            }
        }
        return request as URLRequest
    }
    
    fileprivate func enqueueRequest(_ requestMethod: RequestMethod, _ route: Route, params: JSONDictionary? = nil, sectionName: String? = nil, retryCount: Int = 0, onSuccessResponse: @escaping (String) -> Void, onErrorMessage: @escaping OnErrorMessage) {
        
        let urlRequest = createRequest(requestMethod, route, params: params, sectionName: sectionName)
        print("URL-> \(urlRequest)")
        let dataTask = urlSession.dataTask(with: urlRequest, completionHandler: { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                var statusCode = httpResponse.statusCode
                var responseString:String = ""
                if let responseData = data {
                    responseString = NSString(data: responseData, encoding: String.Encoding.utf8.rawValue) as String? ?? ""
                }else {
                    statusCode = 450
                }
                print(responseString)
                switch statusCode {
                case 200...299:
                    // Success Response
                    
                    onSuccessResponse(responseString)
                    
                    
                default:
                    // Failure Response
                    let errorMessage = "Error Code: \(statusCode)"
                    onErrorMessage(errorMessage)
                }
                
            } else if let error = error {
                var errorMessage: String
                switch error._code {
                case NSURLErrorNotConnectedToInternet:
                    errorMessage = "Net Lost"//Constant.ErrorMessage.InternetConnectionLost
                case NSURLErrorNetworkConnectionLost:
                    if retryCount < self.MAX_RETRIES {
                        self.enqueueRequest(requestMethod, route, params: params, retryCount: retryCount + 1, onSuccessResponse: onSuccessResponse, onErrorMessage: onErrorMessage)
                        return
                        
                    } else {
                        errorMessage = error.localizedDescription
                    }
                default:
                    errorMessage = error.localizedDescription
                }
                onErrorMessage(errorMessage)
                
            } else {
                assertionFailure("Either an httpResponse or an error is expected")
            }
        })
        dataTask.resume()
    }
    
    internal func getDashboardCoverPhotos(onSuccess: @escaping (DashboardCover?) -> Void, onError: @escaping OnErrorMessage) {
        enqueueRequest(.GET, .coverPhoto, onSuccessResponse: { response in
            Parser.sharedInstance.parseDashboardCoverPhotos(jsonString: response, onSuccess: { cover in
                onSuccess(cover)
            })
        }, onErrorMessage: { error in
            onError(error)
        })
    }
    
    internal func getNews(regionID: Int, onSuccess: @escaping (IcymNews?) -> Void, onError: @escaping OnErrorMessage) {
        enqueueRequest(.POST, .news, params: ["region_id" : regionID as AnyObject], onSuccessResponse: { response in
            Parser.sharedInstance.parseNews(jsonString: response, onSuccess: { news in
                onSuccess(news)
            })
        }, onErrorMessage: { error in
            onError(error)
        })
    }
    
    internal func getNewsMultipleImges(newsId: String, onSuccess: @escaping (IcymNews?) -> Void, onError: @escaping OnErrorMessage) {
        enqueueRequest(.POST, .newsMultipleImages, params: ["news_id":newsId as AnyObject], onSuccessResponse: { response in
            Parser.sharedInstance.parseNewsImages(jsonString: response, onSuccess: { newsImages in
                onSuccess(newsImages)
            })
        }, onErrorMessage: { error in
            onError(error)
        })
    }
    
    internal func getNYCNews(onSuccess: @escaping (IcymNews?) -> Void, onError: @escaping OnErrorMessage) {
        enqueueRequest(.GET, .nycNews, onSuccessResponse: { response in
            Parser.sharedInstance.parseNYCNews(jsonString: response, onSuccess: { news in
                onSuccess(news)
            })
        }, onErrorMessage: { error in
            onError(error)
        })
    }
    
    internal func getAYSMagazine(onSuccess: @escaping (AYSMagazines?) -> Void, onError: @escaping OnErrorMessage) {
        enqueueRequest(.GET, .aysMagazine, onSuccessResponse: { response in
            Parser.sharedInstance.parseAYSMagazine(jsonString: response, onSuccess: { magazines in
                onSuccess(magazines)
            })
        }, onErrorMessage: { error in
            onError(error)
        })
    }
    
    internal func getRegionsList(onSuccess: @escaping (IcymRegions?) -> Void, onError: @escaping OnErrorMessage) {
        enqueueRequest(.GET, .regions, onSuccessResponse: { response in
            Parser.sharedInstance.parseRegionsList(jsonString: response, onSuccess: { icymRegions in
                onSuccess(icymRegions)
            })
        }, onErrorMessage: { error in
            onError(error)
        })
    }
    
    internal func getRegionalOfficeAddress(regionID: Int, onSuccess: @escaping (String?) -> Void, onError: @escaping OnErrorMessage) {
        enqueueRequest(.POST, .officeAddress, params: ["region_id":regionID as AnyObject], onSuccessResponse: { response in
            Parser.sharedInstance.parseOfficeAddress(jsonString: response, onSuccess: { address in
                onSuccess(address)
            })
        }, onErrorMessage: { error in
            onError(error)
        })
    }
    
    internal func getRegionalOfficeBearers(regionID: Int, onSuccess: @escaping (OfficeBearers?) -> Void, onError: @escaping OnErrorMessage) {
        enqueueRequest(.POST, .officeBearers, params: ["region_id":regionID as AnyObject], onSuccessResponse: { response in
            Parser.sharedInstance.parseOfficeBearers(jsonString: response, onSuccess: { bearers in
                onSuccess(bearers)
            })
        }, onErrorMessage: { error in
            onError(error)
        })
    }
    
    internal func getRegionalAnnualReport(regionID: Int, onSuccess: @escaping (AnnualReports?) -> Void, onError: @escaping OnErrorMessage) {
        enqueueRequest(.POST, .annualReport, params: ["region_id":regionID as AnyObject], onSuccessResponse: { response in
            Parser.sharedInstance.parseAnnualReports(jsonString: response, onSuccess: { reports in
                onSuccess(reports)
            })
        }, onErrorMessage: { error in
            onError(error)
        })
    }
    
    internal func getRegionalPhotos(regionID: Int, onSuccess: @escaping (RegionalPhotos?) -> Void, onError: @escaping OnErrorMessage) {
        enqueueRequest(.POST, .regionPhotos, params: ["region_id":regionID as AnyObject], onSuccessResponse: { response in
            Parser.sharedInstance.parseRegionalPhotos(jsonString: response, onSuccess: { photos in
                onSuccess(photos)
            })
        }, onErrorMessage: { error in
            onError(error)
        })
    }
    
    internal func getRegionalVideos(regionID: Int, onSuccess: @escaping (RegionalVideos?) -> Void, onError: @escaping OnErrorMessage) {
        enqueueRequest(.POST, .regionVideos, params: ["region_id":regionID as AnyObject], onSuccessResponse: { response in
            Parser.sharedInstance.parseRegionalVideos(arrayKey: "videos", jsonString: response, onSuccess: { videos in
                onSuccess(videos)
            })
        }, onErrorMessage: { error in
            onError(error)
        })
    }
    
    internal func getGoverningBody(updatedAt: String, onSuccess: @escaping (IcymGoverningBody?) -> Void, onError: @escaping OnErrorMessage) {
        enqueueRequest(.POST, .governingBody, params: ["updated":updatedAt as AnyObject], onSuccessResponse: { response in
            Parser.sharedInstance.parseGoverningBodies(
                arrayKey: "governingbody", jsonString: response, onSuccess: { bodies in
                    onSuccess(bodies)
            })
        }, onErrorMessage: { error in
            onError(error)
        })
    }
    
    internal func getNexcoData(updatedAt: String, onSuccess: @escaping (IcymGoverningBody?) -> Void, onError: @escaping OnErrorMessage) {
        enqueueRequest(.POST, .nexco, params: ["updated":updatedAt as AnyObject], onSuccessResponse: { response in
            Parser.sharedInstance.parseGoverningBodies(
                arrayKey: "nexco", jsonString: response, onSuccess: { nexco in
                    onSuccess(nexco)
            })
        }, onErrorMessage: { error in
            onError(error)
        })
    }
    
    internal func getNationalCouncilData(updatedAt: String, onSuccess: @escaping (IcymGoverningBody?) -> Void, onError: @escaping OnErrorMessage) {
        enqueueRequest(.POST, .nationalCouncil, params: ["updated":updatedAt as AnyObject], onSuccessResponse: { response in
            Parser.sharedInstance.parseGoverningBodies(
                arrayKey: "national", jsonString: response, onSuccess: { national in
                    onSuccess(national)
            })
        }, onErrorMessage: { error in
            onError(error)
        })
    }
    
    internal func getNotifications(updatedAt: String, onSuccess: @escaping ([Notification]) -> Void, onError: @escaping OnErrorMessage) {
        enqueueRequest(.POST, .notification, params: ["updated":updatedAt as AnyObject], onSuccessResponse: { response in
            Parser.sharedInstance.parseNotifications(
                jsonString: response, onSuccess: { notifications in
                    onSuccess(notifications)
            })
        }, onErrorMessage: { error in
            onError(error)
        })
    }
    
    internal func getAnimationSongs(updatedAt: String, onSuccess: @escaping ([Video]) -> Void, onError: @escaping OnErrorMessage) {
        enqueueRequest(
            .POST, .animationSongs, params: ["updated":updatedAt as AnyObject], onSuccessResponse: { response in
                Parser.sharedInstance.parseRegionalVideos(arrayKey: "animation_videos", jsonString: response, onSuccess: { icymVideos in
                    onSuccess(icymVideos?.videos ?? [])
                })
        }, onErrorMessage: { error in
            
        })
    }
}
