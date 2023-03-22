//
//  EndPoint.swift
//  SiaraShield-iOS
//
//  Created by ShitalJadav on 21/03/23.
//
import UIKit

public enum HTTPMethod : String {
    case GET     = "GET"
    case POST    = "POST"
    case PUT     = "PUT"
    case PATCH   = "PATCH"
    case DELETE  = "DELETE"
}
enum Result<String>{
    case success
    case failure(String)
}
enum NetworkResponse:String {
    case success
    case authenticationError = "Authentication Error."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
    case unableToEncode = "We could not encode the request"
    case nointernet = "No internet connnectivity."
    case unauthorizeCode = "Session expaired, Login again"
}

final class EndPoint: NSObject {
    
    var baseURL : String = "https://invisiblecaptchaembed.mycybersiara.com/api/"
        
    static let shared = EndPoint()
    
    private override init() {}
    
    func firstAPIURL() -> String {
        return baseURL + "CyberSiara/GetCyberSiaraForAndroid"
    }
    
    func submitCaptchaURL() -> String {
        return baseURL + "SubmitCaptcha/VerifiedSubmitForAndroid"
    }
    
    func generateCaptchaURL() -> String {
        return baseURL + "GenerateCaptcha/CaptchaForAndroid"
    }
    
    func captchaVerifyURL() -> String {
        return baseURL + "SubmitCaptcha/SubmitCaptchInfoForAndroid"
    }

    // MARK: - Network Response flags
    public func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401      : return .failure(NetworkResponse.unauthorizeCode.rawValue)
        case 402...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
