//
//  User.swift
//  OraCodeChallenge
//
//  Created by Kevin Gannon on 2/2/17.
//  Copyright © 2017 Kevin Gannon. All rights reserved.
//

import ObjectMapper
import Foundation

struct UserResponse : Mappable  {
    
    var user: User!
    
    init?(map: Map) {
        if map.JSON["data"] == nil {
            return nil
        }
    }
    
    mutating func mapping(map: Map) {
        user <- map["data"]
    }
}

struct User : Mappable {
    
    var id: Int!
    var name: String!
    var email: String?
    
    init?(map: Map) {

    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        email <- map["email"]
    }
}

struct UserPost : Mappable {
    
    var name: String
    var email: String
    var password: String
    var confirmPassword: String
    
    init?(map: Map) {
        return nil
    }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        email <- map["email"]
        password <- map["password"]
        confirmPassword <- map["password_confirmation"]
    }
    
    init(name: String, email: String, password: String, confirmPassword: String) {
        self.name = name
        self.email = email
        self.password = password
        self.confirmPassword = confirmPassword
    }
}
