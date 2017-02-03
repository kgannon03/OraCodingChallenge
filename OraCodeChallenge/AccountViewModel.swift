//
//  AccountViewModel.swift
//  OraCodeChallenge
//
//  Created by Kevin Gannon on 2/3/17.
//  Copyright © 2017 Kevin Gannon. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AccountViewModel {
    
    let service: AccountService
    let disposeBag = DisposeBag()
    let userResponse: Observable<APIResponse<UserResponse>>
    
    var loadingState = Variable<LoadingState>(.Loading)
    var userEmail = Variable<String>("")
    var userName = Variable<String>("")
    
    init(service: AccountService) {
        self.service = service
        userResponse = service.getUser()
        
        addBindings()
    }
    
    func addBindings() {
        userResponse
            .map{ $0.data?.user.name ?? ""}
            .bindTo(userName)
            .addDisposableTo(disposeBag)
        
        userResponse
            .map{ $0.data?.user.email ?? ""}
            .bindTo(userEmail)
            .addDisposableTo(disposeBag)
        
        userResponse
            .asObservable()
            .map{ next in
                guard let _ = next.data else { return .Error }
                return .Loaded
            }
            .bindTo(loadingState)
            .addDisposableTo(disposeBag)
    }
}
