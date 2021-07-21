//
//  APIManager.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 7/13/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import Foundation
import Alamofire
import KVNProgress

class APIManager {
    
    static let sharedInstance = APIManager()
    private init() {
        print("APIManager Initialized")
    }
    
    public func signIn(provider: String, email: String, password: String, completion: @escaping (_ result: NSDictionary)->()) {
        let parameters = [
            "provider": provider,
            "username": email,
            "password": password
        ]        
        
        let headers = ["Content-Type": "application/json", "accept": "application/json"]
        
        Alamofire.request(Constants.LOGIN, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
            case .success(let JSON):
                let post = JSON as! NSDictionary
                completion(post)
            case .failure(let error):
                KVNProgress.showError(withStatus: error.localizedDescription)
            }
        }
        
    }
    
    public func signInWithSocial(provider: String, token: String, completion: @escaping (_ error: Error?, _ result: Any?) -> Void) {
        let parameters = [
            "provider": provider,
            "token": token
        ]
        
        Alamofire.request(Constants.LOGIN, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let JSON):
                completion(nil, JSON)
            case .failure(let error):
                completion(error, nil)
            }
        }
    }   
    
    public func signUp(email: String, username: String, password: String, completion: @escaping (_ result: NSDictionary)->()) {
        let parameters = [
            "name": username,
            "username": email,
            "password": password,
            //            "token": token
        ]
        
        let headers = ["Content-Type": "application/json", "accept": "application/json"]
        
        Alamofire.request(Constants.REGISTER, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
            case .success(let JSON):
                let post = JSON as! NSDictionary
                completion(post)
            case .failure(let error):
                KVNProgress.showError(withStatus: error.localizedDescription)
            }
        }
    }
    
    public func getPossiblePeople(query: String = "", page: Int = 0, limit: Int = 20, completion: @escaping (Error?, Any?)->()) {
        let url = Constants.GET_POSSIBLE_PEOPLE + "?query=\(query)&page=\(page)&limit=\(limit)"
        
        self.getRequest(url: url, completion: {
            error, result in
            completion(error, result)
        })
    }
    
    public func getFriends(query: String = "", page: Int = 0, limit: Int = 20, completion: @escaping (Error?, Any?)->()) {
        let url = Constants.GET_FRIENDS + "?query=\(query)&page=\(page)&limit=\(limit)"
        
        self.getRequest(url: url, completion: {
            error, result in
            completion(error, result)
        })
    }
    
    public func searchPeopleByUserName(name: String, completion: @escaping (Error?, Any?)->Void) {
        let url = Constants.SEARCH_BY_NAME + "?query=\(name)"
        self.getRequest(url: url, completion: {
            error, result in
            completion(error, result)
        })
        
    }
    
    public func getMyProfile(completion: @escaping (Error?, Any?)->Void) {
        let url = Constants.GET_MY_PROFILE
        self.getRequest(url: url, completion: {
            error, result in
            completion(error, result)
        })
    }
    
    public func uploadAvatar(file: URL, completion: @escaping (Error?, Any?)->Void) {
        let url = Constants.PROFILE_IMAGE
        self.uploadRequest(url: url, file: file, completion: {
            error, result in
            completion(error, result)
        })
    }
    
    public func changeProfile(body: [String: Any], completion: @escaping(Error?, Any?)->Void) {
        let url = Constants.CHANGE_PROFILE
        self.patchRequest(url: url, body: body, completion: {
            error, result in
            completion(error, result)
        })
        
    }
    
    public func getNotifications(page: Int = 0, limit: Int = 20, completion: @escaping (Error?, Any?)->Void) {
        let url = Constants.GET_NOTIFICATIONS + "?page=\(page)&limit=\(limit)"
        self.getRequest(url: url, completion: {
            error, result in
            completion(error, result)
        })
    }
    
    public func connectPeople(id: String, completion: @escaping (Error?, Any?)->Void) {
        let url = Constants.CONNECT_PEOPLE + id
        
        self.postRequest(url: url, body: nil, completion: {
            error, result in
            completion(error, result)
        })
    }
    
    public func disconnectPeople(id: String, completion: @escaping (Error?, Any?)->Void) {
        let url = Constants.DISCONNECT_PEOPLE + id
        
        self.deleteRequest(url: url, completion: {
            error, result in
            completion(error, result)
        })
    }
    
    public func registerPushToken(token: String, completion: @escaping (Error?, Any?)->Void) {
        let url = Constants.REGISTER_PUSH_TOKEN + token
        self.postRequest(url: url, body: nil, completion: {
            error, result in
            completion(error, result)
        })
    }
    
    public func sendMessage(body: [String: Any], completion: @escaping (Error?, Any?)->Void) {
        let url = Constants.SEND_MESSAGE
        self.postRequest(url: url, body: body, completion: {
            error, result in
            completion(error, result)
        })
    }
    
    public func sendMessage(msg: String, id: String, completion: @escaping (Error?, Any?)->Void) {
        let url = Constants.SEND_MESSAGE + "\(id)/write?message=\(msg)"
        self.postRequest(url: url, body: nil, completion: {
            error, result in
            completion(error, result)
        })
    }
    
    public func getMyPosts(page: Int = 0, limit: Int = 20, completion: @escaping (Error?, Any?)->Void) {
        let url = Constants.GET_MYPOSTS + "?page=\(page)&limit=\(limit)"
        self.getRequest(url: url, completion: {
            error, result in
            completion(error, result)
        })
    }
    
    public func getMessages(page: Int = 0, limit: Int = 20, completion: @escaping (Error?, Any?)->Void) {
        let url = Constants.GET_MESSAGES + "?page=\(page)&limit=\(limit)"
        self.getRequest(url: url, completion: {
            error, result in
            completion(error, result)
        })
    }
    
    public func readMessage(id: String, completion: @escaping (Error?, Any?)->Void) {
        let url = Constants.READ_MESSAGE + id
        self.postRequest(url: url, body: nil, completion: {
            error, result in
            completion(error, result)
        })
    }
    
    public func createNewPost(body: [String: Any], completion: @escaping (Error?, Any?)->Void) {
        let url = Constants.CREATE_NEW_POST
        self.postRequest(url: url, body: body, completion: {
            error, result in
            completion(error, result)
        })
    }
    
    public func newPost(file: URL, body: [String: Any], completion: @escaping (Error?, Any?)->Void) {
        let url = Constants.CREATE_NEW_POST
        self.uploadRequest(url: url, file: file, body: body, completion: {
            error, result in
            completion(error, result)
        })
    }
    
    public func getCities(page: Int, limit: Int, query: String, completion: @escaping (Error?, Any?)->Void) {
        let url = Constants.GET_CITIES + "?page=\(page)&limit=\(limit)&query=\(query)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
            case .success(let JSON):
                let post = JSON as! NSDictionary
                completion(nil, post)
            case .failure(let error):
                KVNProgress.showError(withStatus: error.localizedDescription)
            }
        }
    }
    
    public func getNewsFeeds(page: Int, limit: Int, completion: @escaping (Error?, Any?)->Void) {
        let url = Constants.GET_NEWSFEED + "?page=\(page)&limit=\(limit)"
        self.getRequest(url: url, completion: {
            error, result in
            completion(error, result)
        })
    }
    
    public func getCategoryList(type: String, page: Int, limit: Int, lang: String = "EN", completion: @escaping (Error?, Any?)->Void) {
        let url = Constants.GET_CATEGORIES + "\(type)?page=\(page)&limit=\(limit)&lang=\(lang)"
        self.getRequest(url: url, completion: {
            error, result in
            completion(error, result)
        })
    }
    
    public func likePost(postId: String, completion: @escaping (Error?, Any?)->Void) {
        let url = Constants.LIKE_POST + "\(postId)/like"
        self.postRequest(url: url, body: nil, completion: {
            error, result in
            completion(error, result)
        })
    }
    
    public func likeReview(reviewId: String, completion: @escaping (Error?, Any?)->Void) {
        let url = Constants.LIKE_REVIEW + "\(reviewId)/like"
        self.postRequest(url: url, body: nil, completion: {
            error, result in
            completion(error, result)
        })
    }
    
    public func commentPost(postId: String, comment: String, completion: @escaping (Error?, Any?)->Void) {
        let url = Constants.LIKE_POST + "\(postId)/comment"
        let body = [
            "comment": comment
        ]
        self.postRequest(url: url, body: body, completion: {
            error, result in
            completion(error, result)
        })
    }
    
    public func updateTours(cities: [Any], completion: @escaping (Error?, Any?)->Void) {
        let url = Constants.UPDATE_TOURS
        self.postArrayRequest(url: url, body: cities, completion: {
            error, result in
            completion(error, result)
        })
    }
    
    public func getUserTours(id: String, completion: @escaping (Error?, Any?)->Void) {
        let url = Constants.GET_USER_TOURS + "\(id)/tours"
        self.getRequest(url: url, completion: {
            error, result in
            completion(error, result)
        })
    }
    
    public func postReport(body: [String: Any], completion: @escaping (Error?, Any?)->Void) {
        let url = Constants.POST_REPORT
        self.postRequest(url: url, body: body, completion: {
            error, result in
            completion(error, result)
        })
    }
    
    public func recommendPlace(placeId: String, friendId: String, completion: @escaping (Error?, Any?)->Void) {
        let url = Constants.POST_RECOMMEND + "\(placeId)/to/\(friendId)"
        self.postRequest(url: url, body: nil, completion: {
            error, result in
            completion(error, result)
        })
    }
    
    public func getPlaces(city: String, category: String, page: Int, limit: Int, completion: @escaping (Error?, Any?)->Void) {
        let url = Constants.GET_PLACES + "\(city)/\(category)?page=\(page)&limit=\(limit)"
        self.getRequest(url: url, completion: {
            error, result in
            completion(error, result)
        })
    }
    
    public func getPlaceDetail(id: String, completion: @escaping (Error?, Any?)->Void) {
        let url = Constants.GET_PLACES + "\(id)"
        self.getRequest(url: url, completion: {
            error, result in
            completion(error, result)
        })
    }
    
    public func getPlaceReviews(id: String, page: Int, limit: Int, completion: @escaping (Error?, Any?)->Void) {
        let url = Constants.GET_PLACE_REVIEWS + "\(id)?page=\(page)&limit=\(limit)"
        self.getRequest(url: url, completion: {
            error, result in
            completion(error, result)
        })
    }
    
    public func sendReview(placeId: String, body: [String: Any], completion: @escaping (Error?, Any?)->Void) {
        let url = Constants.GET_PLACE_REVIEWS + "\(placeId)"
        self.postRequest(url: url, body: body, completion: {
            error, result in
            completion(error, result)
        })
    }
    
    public func getMessagesChat(id: String, page: Int, limit: Int, completion: @escaping (Error?, Any?)->Void) {
        let url = Constants.GET_MESSAGES_CHAT + "\(id)/messages?page=\(page)&limit=\(limit)"
        self.getRequest(url: url, completion: {
            error, result in
            completion(error, result)
        })
    }
    
    ///////////////////////////General Request///////////////////////////
    
    public func uploadRequest(url: String, file: URL, body: [String: Any]? = nil, completion: @escaping (Error?, Any?)->()) {
        let headers = ["Authorization": "Bearer \(GlobalData.accessToken)"]
        
        Alamofire.upload(multipartFormData: {
            multipartFormData in
            if body != nil {
                let data = try! JSONSerialization.data(withJSONObject: body!)
                multipartFormData.append(data, withName: "post")
            }
            
            multipartFormData.append(file, withName: "file", fileName: "avatar.jpg", mimeType: "image/jpeg")
        }, to: url,//Constants.PROFILE_IMAGE,
           method: .post,
           headers: headers,
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: {
                    response in
                    switch response.result {
                    case .success(let JSON):
                        let post = JSON as? NSDictionary
                        if post != nil {
                            let error = post!["error"] as? NSDictionary
                            if error == nil {
                                completion(nil, JSON)
                            }
                            else {
                                let status = error!["status"] as! Int
                                let detail = error!["detail"] as! String
                                if status == 401 {
                                    self.updateToken(completion: {
                                        res in
                                        
                                        GlobalData.accessToken = res["accessToken"] as! String
                                        GlobalData.refreshToken = res["refreshToken"] as! String
                                        UserDefaults.standard.set(GlobalData.accessToken, forKey: "accessToken")
                                        UserDefaults.standard.set(GlobalData.refreshToken, forKey: "refreshToken")
                                        let headers = ["Authorization": "Bearer \(GlobalData.accessToken)"]
                                        
                                        Alamofire.upload(multipartFormData: {
                                            multipartFormData in
                                            if body != nil {
                                                let data = try! JSONSerialization.data(withJSONObject: body!)
                                                multipartFormData.append(data, withName: "post")
                                            }
                                            multipartFormData.append(file, withName: "file", fileName: "avatar.jpg", mimeType: "image/jpeg")
                                        }, to: Constants.PROFILE_IMAGE,
                                           method: .post,
                                           headers: headers,
                                           encodingCompletion: { encodingResult in
                                            switch encodingResult {
                                            case .success(let upload, _, _):
                                                upload.responseJSON(completionHandler: {
                                                    response in
                                                    switch response.result {
                                                    case .success(let JSON):
                                                        let post = JSON as? NSDictionary
                                                            if post != nil {
                                                                let error = post!["error"] as? NSDictionary
                                                                if error != nil {
                                                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "logout"), object: nil)
                                                                }
                                                                else {
                                                                    completion(nil, JSON)
                                                                }
                                                            }
                                                            else {
                                                                completion(nil, JSON)
                                                        }
                                                    case .failure(let error):
                                                        completion(error, nil)
                                                    }
                                                })
                                            case .failure(let error):
                                                completion(error, nil)
                                            }
                                        })

                                    })
                                }
                                else {
                                    KVNProgress.showError(withStatus: detail)
                                    completion(nil, nil)
                                }
                            }
                        }
                        else {
                            completion(nil, JSON)
                        }
                    case .failure(let error):
                        completion(error, nil)
                    }
                })
            case .failure(let error):
                completion(error, nil)
            }
        })

    }
    
    public func patchRequest(url: String, body: [String: Any]?, completion: @escaping (Error?, Any?)->()) {
        let headers = ["Authorization": "Bearer \(GlobalData.accessToken)"]
        
        Alamofire.request(url, method: .patch, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
            case .success(let JSON):
                let post = JSON as? NSDictionary
                if post != nil {
                    let error = post!["error"] as? NSDictionary
                    if error == nil {
                        completion(nil, JSON)
                    }
                    else {
                        let status = error!["status"] as! Int
                        let detail = error!["detail"] as! String
                        if status == 401 {
                            self.updateToken(completion: {
                                res in
                                
                                GlobalData.accessToken = res["accessToken"] as! String
                                GlobalData.refreshToken = res["refreshToken"] as! String
                                UserDefaults.standard.set(GlobalData.accessToken, forKey: "accessToken")
                                UserDefaults.standard.set(GlobalData.refreshToken, forKey: "refreshToken")
                                let headers = ["Authorization": "Bearer \(GlobalData.accessToken)"]
                                
                                Alamofire.request(url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!, method: .patch, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                                    switch response.result {
                                    case .success(let JSON):
                                        let post = JSON as? NSDictionary
                                        if post != nil {
                                            let error = post!["error"] as? NSDictionary
                                            if error != nil {
                                                NotificationCenter.default.post(name: Notification.Name(rawValue: "logout"), object: nil)
                                            }
                                            else {
                                                completion(nil, JSON)
                                            }
                                        }
                                        else {
                                            completion(nil, JSON)
                                        }
                                        
                                        
                                    case .failure(let error):
                                        completion(error, nil)
                                    }
                                }
                            })
                        }
                        else {
                            KVNProgress.showError(withStatus: detail)
                            completion(nil, nil)
                        }
                    }
                }
                else {
                    completion(nil, JSON)
                }
                
            case .failure(let error):
                completion(error, nil)
            }
        }
    }
    
    public func postRequest(url: String, body: [String: Any]?, completion: @escaping (Error?, Any?)->()) {
                
        let headers = ["Authorization": "Bearer \(GlobalData.accessToken)"]
        
        Alamofire.request(url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
            case .success(let JSON):
                let post = JSON as? NSDictionary
                if post != nil {
                    let error = post!["error"] as? NSDictionary
                    if error == nil {
                        completion(nil, JSON)
                    }
                    else {
                        let status = error!["status"] as! Int
                        let detail = error!["detail"] as! String
                        if status == 401 {
                            self.updateToken(completion: {
                                res in
                                GlobalData.accessToken = res["accessToken"] as! String
                                GlobalData.refreshToken = res["refreshToken"] as! String
                                UserDefaults.standard.set(GlobalData.accessToken, forKey: "accessToken")
                                UserDefaults.standard.set(GlobalData.refreshToken, forKey: "refreshToken")
                                
                                let headers = ["Authorization": "Bearer \(GlobalData.accessToken)"]
                                
                                Alamofire.request(url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                                    switch response.result {
                                    case .success(let JSON):
                                        let post = JSON as? NSDictionary
                                        if post != nil {
                                            let error = post!["error"] as? NSDictionary
                                            if error != nil {
                                                NotificationCenter.default.post(name: Notification.Name(rawValue: "logout"), object: nil)
                                            }
                                            else {
                                                completion(nil, JSON)
                                            }
                                        }
                                        else {
                                            completion(nil, JSON)
                                        }
                                        
                                        
                                    case .failure(let error):
                                        completion(error, nil)
                                    }
                                }
                            })
                        }
                        else {
                            KVNProgress.showError(withStatus: detail)
                            completion(nil, nil)
                        }
                    }
                }
                else {
                    completion(nil, JSON)
                }
                
            case .failure(let error):
                completion(error, nil)
            }
        }
    }
    
    public func postArrayRequest(url: String, body: [Any]?, completion: @escaping (Error?, Any?)->()) {
        
        let headers = ["Authorization": "Bearer \(GlobalData.accessToken)"]
        
        var request = URLRequest(url: URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
        request.httpMethod = "POST"
//        request.setValue("Authorization", forHTTPHeaderField: "Bearer \(GlobalData.accessToken)")
        request.allHTTPHeaderFields = headers
        request.httpBody = try! JSONSerialization.data(withJSONObject: body!)
        
        Alamofire.request(request).responseJSON { response in
            
            switch response.result {
            case .success(let JSON):
                let post = JSON as? NSDictionary
                if post != nil {
                    let error = post!["error"] as? NSDictionary
                    if error == nil {
                        completion(nil, JSON)
                    }
                    else {
                        let status = error!["status"] as! Int
                        let detail = error!["detail"] as! String
                        if status == 401 {
                            self.updateToken(completion: {
                                res in
                                GlobalData.accessToken = res["accessToken"] as! String
                                GlobalData.refreshToken = res["refreshToken"] as! String
                                UserDefaults.standard.set(GlobalData.accessToken, forKey: "accessToken")
                                UserDefaults.standard.set(GlobalData.refreshToken, forKey: "refreshToken")
                                
                                //let headers = ["Authorization": "Bearer \(GlobalData.accessToken)"]
                                
                                Alamofire.request(request).responseJSON { response in
                                    switch response.result {
                                    case .success(let JSON):
                                        let post = JSON as? NSDictionary
                                        if post != nil {
                                            let error = post!["error"] as? NSDictionary
                                            if error != nil {
                                                NotificationCenter.default.post(name: Notification.Name(rawValue: "logout"), object: nil)
                                            }
                                            else {
                                                completion(nil, JSON)
                                            }
                                        }
                                        else {
                                            completion(nil, JSON)
                                        }
                                        
                                        
                                    case .failure(let error):
                                        completion(error, nil)
                                    }
                                }
                            })
                        }
                        else {
                            KVNProgress.showError(withStatus: detail)
                            completion(nil, nil)
                        }
                    }
                }
                else {
                    completion(nil, JSON)
                }
                
            case .failure(let error):
                completion(error, nil)
            }
        }
    }
    
    public func deleteRequest(url: String, completion: @escaping (Error?, Any?)->()) {
        let headers = ["Authorization": "Bearer \(GlobalData.accessToken)"]
        
        Alamofire.request(url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!, method: .delete, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
            case .success(let JSON):
                let post = JSON as? NSDictionary
                if post != nil {
                    let error = post!["error"] as? NSDictionary
                    if error == nil {
                        completion(nil, JSON)
                    }
                    else {
                        let status = error!["status"] as! Int
                        let detail = error!["detail"] as! String
                        if status == 401 {
                            self.updateToken(completion: {
                                res in
                                GlobalData.accessToken = res["accessToken"] as! String
                                GlobalData.refreshToken = res["refreshToken"] as! String
                                UserDefaults.standard.set(GlobalData.accessToken, forKey: "accessToken")
                                UserDefaults.standard.set(GlobalData.refreshToken, forKey: "refreshToken")
                                let headers = ["Authorization": "Bearer \(GlobalData.accessToken)"]
                                
                                Alamofire.request(url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!, method: .delete, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                                    switch response.result {
                                    case .success(let JSON):
                                        let post = JSON as? NSDictionary
                                        if post != nil {
                                            let error = post!["error"] as? NSDictionary
                                            if error != nil {
                                                NotificationCenter.default.post(name: Notification.Name(rawValue: "logout"), object: nil)
                                            }
                                            else {
                                                completion(nil, JSON)
                                            }
                                        }
                                        else {
                                            completion(nil, JSON)
                                        }
                                        
                                        
                                    case .failure(let error):
                                        completion(error, nil)
                                    }
                                }
                            })
                        }
                        else {
                            KVNProgress.showError(withStatus: detail)
                            completion(nil, nil)
                        }
                    }
                }
                else {
                    completion(nil, JSON)
                }
                
            case .failure(let error):
                completion(error, nil)
            }
        }
    }
    
    public func getRequest(url: String, completion: @escaping (Error?, Any?)->()) {
        let headers = ["Authorization": "Bearer \(GlobalData.accessToken)"]
        
        Alamofire.request(url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
            case .success(let JSON):
                let post = JSON as? NSDictionary
                if post != nil {
                    let error = post!["error"] as? NSDictionary
                    if error == nil {
                        completion(nil, JSON)
                    }
                    else {
                        let status = error!["status"] as! Int
                        let detail = error!["detail"] as! String
                        if status == 401 {
                            self.updateToken(completion: {
                                res in
                                GlobalData.accessToken = res["accessToken"] as! String
                                GlobalData.refreshToken = res["refreshToken"] as! String
                                UserDefaults.standard.set(GlobalData.accessToken, forKey: "accessToken")
                                UserDefaults.standard.set(GlobalData.refreshToken, forKey: "refreshToken")
                                let headers = ["Authorization": "Bearer \(GlobalData.accessToken)"]
                                
                                Alamofire.request(url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                                    switch response.result {
                                    case .success(let JSON):
                                        let post = JSON as? NSDictionary
                                        if post != nil {
                                            let error = post!["error"] as? NSDictionary
                                            if error != nil {
                                                NotificationCenter.default.post(name: Notification.Name(rawValue: "logout"), object: nil)
                                            }
                                            else {
                                                completion(nil, JSON)
                                            }
                                        }
                                        else {
                                            completion(nil, JSON)
                                        }
                                        
                                    case .failure(let error):
                                        completion(error, nil)
                                    }
                                }
                            })
                        }
                        else {
                            KVNProgress.showError(withStatus: detail)
                            completion(nil, nil)
                        }
                    }
                }
                else {
                    completion(nil, JSON)
                }
                
            case .failure(let error):
                completion(error, nil)
            }
        }
    }
    
    public func updateToken(completion: @escaping (NSDictionary)->()) {
        
        if GlobalData.refreshToken.count == 0 {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "logout"), object: nil)
            return
        }
        
        let headers = ["Authorization": "Bearer \(GlobalData.refreshToken)"]
        
        Alamofire.request(Constants.UPDATE_TOKEN, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let JSON):
                let post = JSON as! NSDictionary
                
                let error = post["error"] as? NSDictionary
                if error == nil {
                    completion(post)
                }
                else {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "logout"), object: nil)
                }
            case .failure( _):
                NotificationCenter.default.post(name: Notification.Name(rawValue: "logout"), object: nil)
            }
        }
    }
    
}
