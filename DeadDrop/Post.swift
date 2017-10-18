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

struct Data:Encodable, Decodable{
    let messages: [Message]
}

struct Message:Encodable,Decodable {
    
    let UUID: Int
    let message: String
    let timestamp: String
    let latitude: String
    let longitude: String
    
}

struct User: Decodable {
    let address: Address
    let company: Company
    let email: String
    let id: Int
    let name: String
    let phone: String
    let username: String
    let website: String
}

struct Address: Decodable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: Geo
    
}

struct Geo: Decodable {
    let lat: String
    let lng: String
}

struct Company: Decodable {
    let name: String
    let catchPhrase: String
    let bs: String
}
