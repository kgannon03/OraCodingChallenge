//
//  LoginPost.swift
//  OraCodeChallenge
//
//  Created by Kevin Gannon on 2/3/17.
//  Copyright © 2017 Kevin Gannon. All rights reserved.
//

import Foundation
import ObjectMapper

struct LoginPost : Mappable {
    
    var email: String
    var password: String
    
    init?(map: Map) {
        return nil
    }
    
    mutating func mapping(map: Map) {
        email <- map["email"]
        password <- map["password"]
    }
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
