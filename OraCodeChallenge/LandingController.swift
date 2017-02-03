//
//  LandingController.swift
//  OraCodeChallenge
//
//  Created by Kevin Gannon on 2/2/17.
//  Copyright © 2017 Kevin Gannon. All rights reserved.
//

import UIKit
import Hero
import RxCocoa
import RxSwift

class LandingController: UIViewController {

    @IBOutlet weak var splash: UIImageView!
    @IBOutlet weak var login: OraButton!
    @IBOutlet weak var signup: OraButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        isHeroEnabled = true
        
        splash.heroID = "Splash"
        splash.heroModifiers = [.duration(1.0), .zPosition(100)]
        
        login.heroModifiers = [.fade, .delay(0.5), .duration(1.0), .zPosition(100)]
        signup.heroModifiers = [.fade, .delay(0.5), .duration(1.0), .zPosition(100)]
    }
    
    @IBAction func signup(_ sender: Any) {
        let signupNav = UIStoryboard(
            name: "Signup",
            bundle: nil)
            .instantiateViewController(withIdentifier: "SignUp") as! UINavigationController
        
        let signup = signupNav.viewControllers.first as! RegisterController
        
        signup.completed.asObservable()
            .filter{ $0 == true }
            .subscribe{[weak self] next in
                guard let ss = self, let _ = next.element else { return }
                let home = UIStoryboard(name: "Home", bundle: nil).instantiateInitialViewController()!
                
                let signup = ss.presentedViewController
                ss.navigationController?.setViewControllers([home], animated: false)
                signup?.dismiss(animated: true, completion: nil)
            }
            .addDisposableTo(disposeBag)
        
        present(signupNav, animated: true, completion: nil)
    }
    
    @IBAction func login(_ sender: Any) {
        let login = UIStoryboard(
            name: "Login",
            bundle: nil)
            .instantiateViewController(withIdentifier: "Login")
        
        present(login, animated: true, completion: nil)
    }
}
