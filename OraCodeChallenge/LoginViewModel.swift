//
//  LoginViewModel.swift
//  OraCodeChallenge
//
//  Created by Kevin Gannon on 2/3/17.
//  Copyright © 2017 Kevin Gannon. All rights reserved.
//

import RxSwift
import RxCocoa

enum LoginFormStatus {
    case Incomplete
    case Submitting
    case Complete
    case NetworkError
    
    var errorMessage: String? {
        switch self {
        case .Incomplete:
            return "All fields are required"
        case .NetworkError:
            return "Something went wrong \n Please try again"
        default:
            return nil
        }
    }
}

struct LoginViewModel {
    
    var email: String = ""
    var password: String = ""
    
    var formStatus = Variable<LoginFormStatus>(.Incomplete)
    
    let disposeBag = DisposeBag()
    let service: LoginService
    
    init(service: LoginService) {
        self.service = service
        addBindings()
    }
    
    func addBindings() {
        formStatus.asObservable()
            .filter{ $0 == .Submitting }
            .flatMapLatest { _ -> Observable<APIResponse<UserResponse>> in
                let user = LoginPost(
                    email: self.email,
                    password: self.password)
                
                return self.service.login(user: user)
            }
            .subscribe{ next in
                guard let response = next.element else { return }
                guard let data = response.data else {
                    self.formStatus.value = .NetworkError
                    return
                }
                
                self.formStatus.value = .Complete
                
                Session.currentUser = data.user
            }
            .addDisposableTo(disposeBag)
    }
    
    func getFormStatus() -> LoginFormStatus {
        if email.isEmpty { return .Incomplete }
        if password.isEmpty { return .Incomplete }
        
        return .Submitting
    }
    
    mutating func submit(email: String?, password: String?) {
        self.email = email ?? ""
        self.password = password ?? ""
        
        formStatus.value = getFormStatus()
    }
}
