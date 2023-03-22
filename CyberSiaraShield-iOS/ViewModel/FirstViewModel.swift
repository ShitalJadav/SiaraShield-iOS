//
//  FirstViewModel.swift
//  SiaraShield-iOS
//
//  Created by ShitalJadav on 21/03/23.
//

import UIKit
import Foundation

class FirstViewModel: NSObject {
    
    var firstReq = firstRequest()
    
    func firstAPICall() {
        let url = EndPoint.shared.firstAPIURL()
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethod.POST.rawValue
        
        let header = [
                "Content-Type" : "application/json"
            ]
        firstReq.masterUrlId = masterUrlId
        firstReq.requestUrl = requestUrl
        firstReq.browserIdentity = browserIdentity
        firstReq.deviceIp = deviceIp ?? ""
        firstReq.deviceType = deviceType
        firstReq.deviceBrowser = deviceBrowser
        firstReq.deviceName = deviceName
        firstReq.deviceHeight = deviceHeight
        firstReq.deviceWidth = deviceWidth

        guard let jsonObj = try firstReq.dictionary else {
            return
        }
        
        if (!JSONSerialization.isValidJSONObject(jsonObj)) {
               print("is not a valid json object")
               return
           }
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: jsonObj, options: []) else {
            return
        }
        request.httpBody = httpBody
        request.allHTTPHeaderFields = header
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                print(response)
            }
            guard data != nil else {
                print("data is nil")
                return
            }
            do {
                let decoder = JSONDecoder()
                if let resData = data {
                    if let json = (try? JSONSerialization.jsonObject(with: resData, options: [])) as? Dictionary<String,AnyObject>
                                       {
                        if let httpStatusCode = json["HttpStatusCode"] as? Int {
                            if httpStatusCode == 200 || httpStatusCode == 0 {
                                if let reqId = json["RequestId"] as? String {
                                    requestId = reqId
                                }
                                if let visId = json["Visiter_Id"] as? String {
                                    visiter_Id = visId
                                }
                            }
                        }
                    }
                    let firstData = try decoder.decode(firstResponse.self, from: resData)
                    
                    if let statusCode = firstData.HttpStatusCode {
                        
                        print(statusCode)
                        if statusCode == 200 || statusCode == 0  {
                            if let reqId = firstData.RequestId {
                                requestId = reqId
                            }
                            if let visId = firstData.Visiter_Id {
                                visiter_Id = visId
                            }
                        }
                    }
                   
                } else {
                    print("No Data Found")
                }
            }
            catch {
                print("JSONSerialization error:", error)
            }
            
        }.resume()
    }
    
}
