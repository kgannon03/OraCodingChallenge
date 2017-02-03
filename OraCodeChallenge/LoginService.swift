//
//  LoginService.swift
//  OraCodeChallenge
//
//  Created by Kevin Gannon on 2/3/17.
//  Copyright © 2017 Kevin Gannon. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import ObjectMapper
import Alamofire

struct LoginService {
    
    enum ResourcePath: String {
        case Login = "/auth/login"
        
        var path: String {
            return Session.baseURL + rawValue
        }
    }
    
    func login(user: LoginPost) -> Observable<APIResponse<UserResponse>> {
        let path = ResourcePath.Login.path
        let params = user.toJSON()
        
        return Observable.create { observer in
            let req = request(
                path,
                method: .post,
                parameters: params,
                encoding: JSONEncoding.default).responseJSON { data in
                    switch data.result {
                    case .success(let json):
                        if
                            let dict = json as? [String : Any],
                            let user = UserResponse(JSON: dict),
                            let token = data.response?.allHeaderFields["Authorization"] as? String {
                            
                            observer.onNext(APIResponse<UserResponse>(data: user))
                            
                            // TODO: Replace with Keychain
                            UserDefaults.standard.set(token, forKey: Constants.UserDefaultKeys.authTokenKey)
                            return
                        }
                        
                        if
                            let dict = json as? [String : Any],
                            let error = APIErrorResponse(JSON: dict) {
                            
                            observer.onNext(APIResponse<UserResponse>(apiError: error))
                            return
                        }
                        
                        observer.onNext(APIResponse<UserResponse>(networkError: .CouldNotParse))
                        
                    case .failure(let error):
                        observer.onNext(APIResponse<UserResponse>(networkError: .Network(error: error)))
                    }
            }
            
            return Disposables.create {
                req.cancel()
            }
        }
    }
}
