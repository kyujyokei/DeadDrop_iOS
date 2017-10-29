//
//  Post.swift
//  DeadDrop
//
//  Created by Kero on 2017/10/16.
//  Copyright © 2017年 Kei. All rights reserved.
//

import Foundation

struct Package:Encodable, Decodable{
    let data: Data
}

struct PackageForPost:Encodable, Decodable{
    let data: DataForPost
}

struct Data:Encodable, Decodable{
    let messages: [Message]
}

struct DataForPost:Encodable, Decodable{
    let message: MessageForPost
}

struct Message:Codable {
    
//    let uuid: Int
    let message: String
    let timestamp: String
    let latitude: String
    let longitude: String
    
}

struct MessageForPost:Codable {
    let message: String
    let timestamp: String
    let latitude: String
    let longitude: String
}

struct Response:Codable {
    let response: String
    
}


