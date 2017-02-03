//
//  Chats.swift
//  OraCodeChallenge
//
//  Created by Kevin Gannon on 2/2/17.
//  Copyright © 2017 Kevin Gannon. All rights reserved.
//

import Foundation
import ObjectMapper

struct ChatList : Mappable  {
    
    var chatArray: [Chat]!
    
    init?(map: Map) {
        if map.JSON["data"] == nil {
            return nil
        }
    }
    
    mutating func mapping(map: Map) {
        chatArray <- map["data"]
    }
}

struct Chat : Mappable  {
    
    var id: Int!
    var name: String?
    var users: [User]!
    var lastMessage: ChatMessage!
    
    init?(map: Map) {

    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        users <- map["users"]
        lastMessage <- map["last_chat_message"]
    }
}

struct ChatMessage : Mappable  {
    
    var id: Int!
    var chatID: Int!
    var userID: Int!
    var message: String!
    var createdDate: String!
    var user: User!
    
    init?(map: Map) {

    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        chatID <- map["chat_id"]
        userID <- map["user_id"]
        message <- map["message"]
        createdDate <- map["created_at"]
        user <- map["user"]
    }
}
