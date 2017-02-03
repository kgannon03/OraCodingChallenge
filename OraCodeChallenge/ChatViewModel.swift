//
//  ChatViewModel.swift
//  OraCodeChallenge
//
//  Created by Kevin Gannon on 2/2/17.
//  Copyright © 2017 Kevin Gannon. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum LoadingState {
    case Loading
    case Loaded
    case Error
    case Empty
}

struct ChatViewModel {
    
    let service: ChatService
    let disposeBag = DisposeBag()
    
    var chatListResponse: Observable<APIResponse<ChatList>> = .empty()
    var chatList = Variable<[Chat]>([])
    var loadingState = Variable<LoadingState>(.Loading)
    
    init(service: ChatService) {
        self.service = service
        addBindings()
    }
    
    mutating func addBindings() {
        chatListResponse = service.getChatList()
        chatListResponse
            .map{ $0.data?.chatArray ?? [] }
            .bindTo(chatList)
            .addDisposableTo(disposeBag)
        
        chatListResponse
            .asObservable()
            .map{ next in
                guard let data = next.data else { return .Error }
                return data.chatArray.isEmpty ? .Empty : .Loaded
            }
            .bindTo(loadingState)
            .addDisposableTo(disposeBag)
    }
}
