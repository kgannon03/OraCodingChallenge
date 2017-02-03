//
//  AccountService.swift
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

struct AccountService {
    
    enum ResourcePath: String {
        case Chats = "/users/current"
        
        var path: String {
            return Session.baseURL + rawValue
        }
    }
    
    func getUser() -> Observable<APIResponse<UserResponse>> {
        let path = ResourcePath.Chats.path
        let headers: HTTPHeaders = [
            "Authorization": Session.authToken
        ]
        
        return Observable.create { observer in
            let req = request(
                path,
                method: .get,
                headers: headers).responseJSON { data in
                    switch data.result {
                    case .success(let json):
                        if
                            let dict = json as? [String : Any],
                            let user = UserResponse(JSON: dict) {
                            
                            observer.onNext(APIResponse<UserResponse>(data: user))
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
