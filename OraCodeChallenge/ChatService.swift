//
//  ChatService.swift
//  OraCodeChallenge
//
//  Created by Kevin Gannon on 2/2/17.
//  Copyright © 2017 Kevin Gannon. All rights reserved.
//

import Foundation

import Foundation
import RxCocoa
import RxSwift
import ObjectMapper
import Alamofire

struct ChatService {
    
    enum ResourcePath: String {
        case Chats = "/chats"
        
        var path: String {
            return Session.baseURL + rawValue
        }
    }
    
    func getChatList(page: Int = 1, limit: Int = 30) -> Observable<APIResponse<ChatList>> {
        let path = ResourcePath.Chats.path
        let params = [
            "page" : page,
            "limit" : limit
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": Session.authToken
        ]
        
        return Observable.create { observer in
            let req = request(
                path,
                method: .get,
                parameters: params,
                encoding: URLEncoding.default,
                headers: headers).responseJSON { data in
                    switch data.result {
                    case .success(let json):
                        if
                            let dict = json as? [String : Any],
                            let chatList = ChatList(JSON: dict) {
                            
                            observer.onNext(APIResponse<ChatList>(data: chatList))
                            return
                        }
                        
                        if
                            let dict = json as? [String : Any],
                            let error = APIErrorResponse(JSON: dict) {
                            
                            observer.onNext(APIResponse<ChatList>(apiError: error))
                            return
                        }
                        
                        observer.onNext(APIResponse<ChatList>(networkError: .CouldNotParse))
                        
                    case .failure(let error):
                        observer.onNext(APIResponse<ChatList>(networkError: .Network(error: error)))
                    }
            }
            
            return Disposables.create {
                req.cancel()
            }
        }
    }
}
