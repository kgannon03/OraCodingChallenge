//
//  RegisterService.swift
//  OraCodeChallenge
//
//  Created by Kevin Gannon on 2/2/17.
//  Copyright © 2017 Kevin Gannon. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import ObjectMapper
import Alamofire

struct RegisterService {
    
    enum ResourcePath: String {
        case Users = "/users"
        
        var path: String {
            return Session.baseURL + rawValue
        }
    }
    
    func register(user: UserPost) -> Observable<APIResponse<User>> {
        let path = ResourcePath.Users.path
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
                            let user = User(JSON: dict),
                            let token = data.response?.allHeaderFields["Authorization"] as? String {
                            
                            observer.onNext(APIResponse<User>(data: user))
                            
                            // TODO: Replace with Keychain
                            UserDefaults.standard.set(token, forKey: "auth")
                            return
                        }
        
                        if
                            let dict = json as? [String : Any],
                            let error = APIErrorResponse(JSON: dict) {
                            
                            observer.onNext(APIResponse<User>(apiError: error))
                            return
                        }
                        
                        observer.onNext(APIResponse<User>(networkError: .CouldNotParse))
                        
                    case .failure(let error):
                        observer.onNext(APIResponse<User>(networkError: .Network(error: error)))
                    }
            }
            
            return Disposables.create {
                req.cancel()
            }
        }
    }
}
