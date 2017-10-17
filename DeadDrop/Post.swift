//
//  Post.swift
//  DeadDrop
//
//  Created by Kero on 2017/10/16.
//  Copyright © 2017年 Kei. All rights reserved.
//

import Foundation

struct Data:Encodable, Decodable{
    let message: Message
}

struct Message:Encodable,Decodable {
    
    let UUID: String
    let message: String
    let timestamp: String
    let latitude: Double
    let longitude: Double
    
}
