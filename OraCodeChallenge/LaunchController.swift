//
//  LaunchController.swift
//  OraCodeChallenge
//
//  Created by Kevin Gannon on 2/2/17.
//  Copyright © 2017 Kevin Gannon. All rights reserved.
//

import UIKit
import Hero

class LaunchController: UIViewController {

    @IBOutlet weak var splash: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isHeroEnabled = true
        
        splash.heroID = "Splash"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let landing = UIStoryboard(
                name: "Landing",
                bundle: nil)
                .instantiateViewController(withIdentifier: "Landing")
            
            self.navigationController?.pushViewController(landing, animated: true)
        }
    }
}
