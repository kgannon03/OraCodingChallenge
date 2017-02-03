//
//  AccountController.swift
//  OraCodeChallenge
//
//  Created by Kevin Gannon on 2/3/17.
//  Copyright © 2017 Kevin Gannon. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class AccountController: UIViewController {

    @IBOutlet weak var email: OraFormField!
    @IBOutlet weak var name: OraFormField!
    @IBOutlet weak var save: OraButton!
    @IBOutlet weak var loaderView: UIView!
    
    let viewModel = AccountViewModel(service: AccountService())
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addBindings()
    }
    
    func addBindings() {
        viewModel.loadingState
            .asObservable()
            .map{ $0 == .Loading ? false : true }
            .bindTo(loaderView.rx.isHidden)
            .addDisposableTo(disposeBag)
        
        viewModel.userEmail
            .asObservable()
            .bindTo(email.rx.text)
            .addDisposableTo(disposeBag)
        
        viewModel.userName
            .asObservable()
            .bindTo(name.rx.text)
            .addDisposableTo(disposeBag)
    }
}
