//
//  LoginController.swift
//  OraCodeChallenge
//
//  Created by Kevin Gannon on 2/2/17.
//  Copyright © 2017 Kevin Gannon. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LoginController: UIViewController {

    @IBOutlet weak var password: OraFormField!
    @IBOutlet weak var email: OraFormField!
    @IBOutlet weak var login: OraButton!
    
    var viewModel = LoginViewModel(service: LoginService())
    
    let disposeBag = DisposeBag()
    
    var completed = Variable<Bool>(false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBindings()
    }
    
    func addBindings() {
        viewModel.formStatus
            .asObservable()
            .filter{ $0 == .Submitting }
            .subscribe{[weak self] next in
                guard let ss = self else { return }
                ss.login.setTitle("SIGNING IN...", for: .normal)
                ss.login.backgroundColor = Constants.Colors.oraBlue
            }
            .addDisposableTo(disposeBag)
        
        viewModel.formStatus
            .asObservable()
            .filter{ $0 == .Complete }
            .subscribe{[weak self] next in
                guard let ss = self else { return }
                ss.completed.value = true
            }
            .addDisposableTo(disposeBag)
        
        viewModel.formStatus
            .asObservable()
            .skip(1)
            .filter{ $0.errorMessage != nil }
            .subscribe{[weak self] next in
                guard let ss = self, let status = next.element else { return }
                ss.login.setTitle("SIGN IN", for: .normal)
                ss.login.backgroundColor = Constants.Colors.oraOrange
                
                let alert = UIAlertController(title: status.errorMessage, message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                ss.present(alert, animated: true, completion: nil)
            }
            .addDisposableTo(disposeBag)
    }

    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func login(_ sender: Any) {
        viewModel.submit(
            email: email.text,
            password: password.text)
    }
}
