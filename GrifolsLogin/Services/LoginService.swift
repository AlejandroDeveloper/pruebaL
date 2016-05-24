//
//  LoginService.swift
//  GrifolsLogin
//
//  Created by Alejandro Palomo Rodriguez on 24/5/16.
//
//

import Foundation
import UIKit
import Alamofire

enum GRStatusCode: String {
    case GRStatusCodeNoError = "0"
    case GRStatusCodeNoUserAccess = "1"
    case GRStatusCodeContentNotFound = "2"
    case GRStatusCodeGenericException = "3"
    case GRStatusCodeJSONParseError = "4"
    case GRStatusCodePortalException = "5"
    case GRStatusCodeSystemException = "6"
    case GRStatusCodeThemeDisplayCreationException = "7"
    case GRStatusCodePrincipalException = "8"
    case GRStatusCodeRepositoryException = "9"
    case GRStatusCodeFieldsValidationError = "10"
    case GRStatusCodeEntityNotCreated = "11"
    case GRStatusCodeUserNotAuthenticated = "12"
    
    func grDescription() -> String {
        switch self {
        case .GRStatusCodeNoError:
            return ("Without error code")
        case .GRStatusCodeNoUserAccess:
            return ("User doesn’t have access to this site")
        case .GRStatusCodeContentNotFound:
            return ("Content not found")
        case .GRStatusCodeGenericException:
            return ("Generic exception")
        case .GRStatusCodeJSONParseError:
            return ("JSON parsering error")
        case .GRStatusCodePortalException:
            return ("Portal exception")
        case .GRStatusCodeSystemException:
            return ("System exception")
        case .GRStatusCodeThemeDisplayCreationException:
            return ("Principal exception")
        case .GRStatusCodePrincipalException:
            return ("Repository exception")
        case .GRStatusCodeRepositoryException:
            return ("Repository exception")
        case .GRStatusCodeFieldsValidationError:
            return ("Fields validation exception")
        case .GRStatusCodeEntityNotCreated:
            return ("Entity not created")
        case .GRStatusCodeUserNotAuthenticated:
            return ("User not authenticated")
        }
    }
}

class LoginService {
    static let sharedInstance = LoginService()
    
    private let grHost = "https://grifolstest.grifols.com"
    private let serviceId = 10154
    private let siteId = 944809
    private var manager: Manager
    
    private init() {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.HTTPCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        self.manager = Alamofire.Manager(configuration: config)
    }
    
    //MARK:-CHECK RESPONSE
    private func checkCommonResponse(response: Response<AnyObject, NSError>) -> (succeded: Bool, statusCode: Int, errorDescription: String) {
        
        // Check statusCode
        guard let httpStatusCode = response.response?.statusCode else {
            return (false, -1, "Response with no statusCode !?!?!?!")
        }
        
        // Check response is successful
        guard response.result.isSuccess else {
            let errorMessage = response.result.error?.localizedDescription
            return (false, httpStatusCode, "Server responded with error: \(errorMessage)")
        }
        
        // Check valid JSON data format
        guard let responseJSON = response.result.value as? [String: AnyObject] else {
            return (false, httpStatusCode, "Response received not in a valid JSON data format")
        }
        
        // Check status key
        guard let statusJSON = responseJSON["status"] as? String,
            let statusCode = GRStatusCode(rawValue:statusJSON) else {
                // Check exception
                guard responseJSON["exception"] == nil else {
                    let responseException = responseJSON["exception"]!
                    return (false, httpStatusCode, "Liferay 'exception' key found in response:\n\(responseException)")
                }
                
                return (false, httpStatusCode, "'status' key not found in response:\n\(response.result.value! ?? "")")
        }
        
        // Check statusCode is Ok
        guard statusCode == GRStatusCode.GRStatusCodeNoError else {
            return (false, httpStatusCode, "StatusCode error: '\(statusCode.rawValue)' -> \(statusCode.grDescription())")
        }
        
        return (true, httpStatusCode, "")
    }
    
    //MARK:-SIGN IN
    func signInWithUser(username:String,password:String) {
        let serviceValues : (URL: String, parameters: [String:AnyObject]) = {
                let url = "\(grHost)/login-service-portlet/api/jsonws/useraccess/username-sign-in"
                let parameters = ["serviceId" : self.serviceId,
                                  "userName" : username,
                                  "password" : password]
                return (url, parameters as! [String : AnyObject])
        }()
        
        self.manager.request(
            .POST,
            serviceValues.URL,
            //            headers: headers,
            parameters: serviceValues.parameters)
            .authenticate(user: username, password: password)
            .validate()
            .responseJSON { (response: Response<AnyObject, NSError>) in
                
                // print response
                print("\(response)")
                
//                let checkResponse = self.checkCommonResponse(response)
//                guard checkResponse.succeded else {
//                    failure(checkResponse.statusCode, checkResponse.errorDescription)
//                    return
//                }
                
//               // Check User structure
//                guard let responseJSON = response.result.value as? [String: AnyObject],
//                    let userJSON = responseJSON["user"] as? [String: AnyObject] else {
//                        failure(checkResponse.statusCode, "'user' key not found in response:\n\(response.result.value ?? "")")
//                        return
//                }
                
//                // Parse userJSON to User Object and check
//                guard let user = Mapper<User>().map(userJSON) else {
//                    failure (checkResponse.statusCode, "Error mapping userJSON to User Object")
//                    return
//                }

        }
        
    }

}