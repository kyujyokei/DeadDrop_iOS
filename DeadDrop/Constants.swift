//
//  Constants.swift
//  DeadDrop
//
//  Created by Kero on 2017/10/14.
//  Copyright © 2017年 Kei. All rights reserved.
//

import Foundation

struct Constants {

    struct ParamKeys{
        static let UUID = "UUID"
        static let message = "message"
        static let timeStamp = "timestamp"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let range = "range"
    }
    
    struct Messages {
        static let MessageBaseURL = "/api/message" // fill this out when API is published
    }
    
    struct MessageResponseKeys{
        static let UUID = "UUID"
        static let message = "message"
        static let timeStamp = "timestamp"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let data = "data"
        static let messages = "messages"
    }

}
