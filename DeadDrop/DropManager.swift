//
//  classes.swift
//  DeadDrop
//
//  Created by Kero on 2017/10/2.
//  Copyright © 2017年 Kei. All rights reserved.
//

import Foundation
import MapKit

class Drop {
    
    var latitude:CLLocationDegrees = 0.0
    var longtitude:CLLocationDegrees = 0.0
    var message:String?
    var date:String?
    
    init(lat:CLLocationDegrees,long:CLLocationDegrees,message:String,date:String){
        self.latitude = lat
        self.longtitude = long
        self.message = message
        self.date = date
    }
}

class DropManager {
    static var drops:[Drop] = []
    
    @discardableResult
    init(){
        DropManager.add(drop: Drop(lat: 1.1, long: 2.2, message: "Hi", date: ""))
        DropManager.add(drop: Drop(lat: 1.1, long: 2.2, message: "Great to see you", date: ""))
        DropManager.add(drop: Drop(lat: 1.1, long: 2.2, message: "Boo", date: ""))
    }
    
    static func add(drop:Drop){
        DropManager.drops.append(drop)
    }
    
    static func delete(index:Int){
        DropManager.drops.remove(at: index)
    }
    
    static func clearAll () {
            DropManager.drops.removeAll()
    }
    
}


class UserAnnotation: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    let userid: Int
//    var pinTintColor: MKPinAnnotationColor = MKPinAnnotationColor.purple
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D, userid: Int, pinTIntColor: UIColor ) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        self.userid = userid
        
        super.init()
    }
}
