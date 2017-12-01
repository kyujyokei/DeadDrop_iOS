//
//  CustomAnnotation.swift
//  DeadDrop
//
//  Created by Kero on 2017/11/30.
//  Copyright © 2017年 Kei. All rights reserved.
//

import UIKit
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
//    let message: String?
    let date: String
//    let userName: String?
    let userId: Int
    let messageId: Int
    let likeCount: Int
    let dislikeCount: Int
    var coordinate: CLLocationCoordinate2D
    //    var pinTintColor: MKPinAnnotationColor = MKPinAnnotationColor.purple
    
    init(title: String, date: String, subtitle: String, userId: Int, messageId:Int, likeCount: Int, dislikeCount: Int , coordinate: CLLocationCoordinate2D) {

        self.title = title
        self.date = date
        self.subtitle = subtitle
        self.userId = userId
        self.messageId = messageId
        self.likeCount = likeCount
        self.dislikeCount = dislikeCount
        self.coordinate = coordinate
        
        super.init()
    }
}
