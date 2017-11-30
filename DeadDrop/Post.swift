//
//  Post.swift
//  DeadDrop
//
//  Created by Kero on 2017/10/16.
//  Copyright © 2017年 Kei. All rights reserved.
//

import Foundation

//struct JSON: Codable {
//    struct Data: Codable {
//        struct Message: Codable {
//            let message: String?
//            let timestamp: String?
//            let latitude: String?
//            let longitude: String?
//        }
//        let messages: [Message]
//    }
//    let data = Data?
//}


struct BaseURL:Codable {
    let DeaddropLive = "https://deaddrop.live"
    let LocalHost = "http://locaohost:443"
}

struct Package:Encodable, Decodable{
    let data: RequestData
}

struct PackageForPost:Encodable, Decodable{
    let data: DataForPost
}

struct RequestData:Encodable, Decodable{
    let messages: [Message]
}

struct DataForPost:Encodable, Decodable{
    let message: MessageForPost
}

struct Message:Codable {
    let message: String
    let timestamp: String
    let latitude: String
    let longitude: String
    let creator_username: String
    let creator_id: Int
    let message_id: Int
    let like_count: Int
    let dislike_count: Int
}

struct ErrorMessage:Codable {
    let message: String?
    let success: Bool?
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

struct User: Codable {
    let username: String
    let password: String
}

struct SuccessResponse: Codable {
    let success: Bool
    let message: String?
}

struct TokenResponse: Codable {
    let success: Bool
    let data: String?
    let message: String?
}

struct MessageForLike: Codable {
    let message_id: Int
    
}



