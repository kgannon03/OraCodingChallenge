//
//  LandingController.swift
//  OraCodeChallenge
//
//  Created by Kevin Gannon on 2/2/17.
//  Copyright © 2017 Kevin Gannon. All rights reserved.
//

import UIKit
import Hero

class LandingController: UIViewController {

    @IBOutlet weak var splash: UIImageView!
    @IBOutlet weak var login: OraButton!
    @IBOutlet weak var signup: OraButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        isHeroEnabled = true
        
        splash.heroID = "Splash"
        splash.heroModifiers = [.duration(1.0), .zPosition(100)]
        
        login.heroModifiers = [.fade, .delay(0.5), .duration(1.0), .zPosition(100)]
        signup.heroModifiers = [.fade, .delay(0.5), .duration(1.0), .zPosition(100)]
    }
    
    @IBAction func signup(_ sender: Any) {
        let signup = UIStoryboard(
            name: "Signup",
            bundle: nil)
            .instantiateViewController(withIdentifier: "SignUp")
        
        present(signup, animated: true, completion: nil)
    }
    
    @IBAction func login(_ sender: Any) {
        let login = UIStoryboard(
            name: "Login",
            bundle: nil)
            .instantiateViewController(withIdentifier: "Login")
        
        present(login, animated: true, completion: nil)
    }
}
