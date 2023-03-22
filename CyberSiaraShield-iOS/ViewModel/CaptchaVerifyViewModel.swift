//
//  CaptchaVerifyViewModel.swift
//  SiaraShield_iOS
//
//  Created by ShitalJadav on 21/03/23.
//

import UIKit

class CaptchaVerifyViewModel: NSObject {
    
    var captchaVerifyReq = captchVerifyRequest()
    
    func captchaVerifyAPICall(userCaptcha: String, completion: @escaping( _ ifResult: Bool) -> Void) {
        let url = EndPoint.shared.captchaVerifyURL()
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethod.POST.rawValue
        captchaVerifyReq.masterUrlId = masterUrlId
        captchaVerifyReq.deviceIp = deviceIp ?? ""
        captchaVerifyReq.deviceType = deviceType
        captchaVerifyReq.deviceName = deviceName
        captchaVerifyReq.userCaptcha = userCaptcha
        captchaVerifyReq.byPass = "Netural"
        captchaVerifyReq.browserIdentity = browserIdentity
        captchaVerifyReq.timespent = "24"
        captchaVerifyReq.strProtocol = protocol_Value
        captchaVerifyReq.flag = "1"
        captchaVerifyReq.second = "2"
        captchaVerifyReq.requestID = requestId
        captchaVerifyReq.fillupsecond = "8"

        guard let jsonObj = try captchaVerifyReq.dictionary else {
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
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
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
                        if let msg = json["Message"] as? String {
                            if msg == "Sucess" || msg == "sucess" {
                                completion(true)
                            } else if msg == "fail" || msg == "Fail" {
                                completion(false)
                            } else {
                                completion(false)
                            }
                        } else {
                            completion(false)
                        }
                    }
                    else {
                        completion(false)
                    }
//                    let verifyData = try decoder.decode(captchaVerifyResponse.self, from: resData)
//
//                    if let statusCode = verifyData.HttpStatusCode {
//
//                        print(statusCode)
//                        if statusCode == 200 || statusCode == 0  {
//                           completion(true)
//                        } else {
//                            completion(false)
//                        }
//                    }
                    
                } else {
                    print("No Data Found")
                    completion(false)
                }
            }
            
        }.resume()
    }
}
