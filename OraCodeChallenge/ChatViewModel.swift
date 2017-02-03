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

class ChatViewModel {
    
    let service: ChatService
    let pageSize: Int = 30
    let disposeBag = DisposeBag()
    let chatListResponse: Observable<APIResponse<ChatList>>
    
    var chatListScrollResponse: Observable<APIResponse<ChatList>> = .empty()
    var chatList = Variable<[Chat]>([])
    var loadingState = Variable<LoadingState>(.Loading)
    var page = Variable<Int>(1)
    
    init(service: ChatService) {
        self.service = service
        chatListResponse = service.getChatList(limit: pageSize)
        
        addBindings()
    }
    
    func addBindings() {
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
        
        chatListScrollResponse = page
            .asObservable()
            .distinctUntilChanged()
            .skip(1)
            .flatMapLatest{[weak self] page -> Observable<APIResponse<ChatList>> in
                guard let ss = self else { return .empty() }
                return ss.service.getChatList(page: page, limit: ss.pageSize)
        }
        
        chatListScrollResponse
            .asObservable()
            .subscribe{[weak self] next in
                guard let ss = self, let data = next.element?.data?.chatArray else { return }
                ss.chatList.value = [ss.chatList.value, data].flatMap { $0 }
        }.addDisposableTo(disposeBag)
    }
}
