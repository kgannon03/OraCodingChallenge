//
//  RegisterViewModel.swift
//  OraCodeChallenge
//
//  Created by Kevin Gannon on 2/2/17.
//  Copyright © 2017 Kevin Gannon. All rights reserved.
//

import RxSwift
import RxCocoa

enum FormStatus {
    case PasswordsDontMatch
    case Incomplete
    case Submitting
    case Complete
    case NetworkError
    
    var errorMessage: String? {
        switch self {
        case .Incomplete:
            return "All fields are required"
        case .PasswordsDontMatch:
            return "Passwords do not match"
        case .NetworkError:
            return "Something went wrong \n Please try again"
        default:
            return nil
        }
    }
}

struct RegisterViewModel {
    
    var name: String = ""
    var email: String = ""
    var password : String = ""
    var confirmPassword: String = ""
    
    var formStatus = Variable<FormStatus>(.Incomplete)
    
    let disposeBag = DisposeBag()
    let service: RegisterService
    
    init(service: RegisterService) {
        self.service = service
        addBindings()
    }
    
    func addBindings() {
        formStatus.asObservable()
            .filter{ $0 == .Submitting }
            .flatMapLatest { _ -> Observable<APIResponse<UserResponse>> in
                let user = UserPost(
                    name: self.name,
                    email: self.email,
                    password: self.password,
                    confirmPassword: self.confirmPassword)
                
                return self.service.register(user: user)
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
    
    func getFormStatus() -> FormStatus {
        if name.isEmpty { return .Incomplete }
        if email.isEmpty { return .Incomplete }
        if password.isEmpty { return .Incomplete }
        if confirmPassword.isEmpty { return .Incomplete }
        
        return password == confirmPassword ? .Submitting : .PasswordsDontMatch
    }
    
    mutating func submit(name: String?, email: String?, password: String?, confirmPassword: String?) {
        self.name = name ?? ""
        self.email = email ?? ""
        self.password = password ?? ""
        self.confirmPassword = confirmPassword ?? ""
        
        formStatus.value = getFormStatus()
    }
}
