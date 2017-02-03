//
//  APIBaseResponse.swift
//  OraCodeChallenge
//
//  Created by Kevin Gannon on 2/2/17.
//  Copyright © 2017 Kevin Gannon. All rights reserved.
//

import ObjectMapper
import Foundation

enum NetworkError: Error {
    case Network(error: Error)
    case CouldNotParse
}

struct APIResponse<T:Mappable> {
    var data: T?
    var apiError: APIErrorResponse?
    var networkError: NetworkError?
    
    init(data: T? = nil, apiError: APIErrorResponse? = nil, networkError: NetworkError? = nil) {
        self.data = data
        self.apiError = apiError
        self.networkError = networkError
    }
}

struct APIErrorResponse : Mappable {
    
    var errors = [String]()
    var errorMessage: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        errors <- map["errors.name"]
        errorMessage <- map["message"]
    }
}
