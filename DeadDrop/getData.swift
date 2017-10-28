//
//  getData.swift
//  DeadDrop
//
//  Created by Kero on 2017/10/19.
//  Copyright © 2017年 Kei. All rights reserved.
//

import Foundation
import MapKit

//func getData(latitude:CLLocationDegrees, longitude:CLLocationDegrees) {
//    
//    print("get")
//    guard let url = URL(string: "https://deaddrop.live/api/message?latitude=\(latitude)&longitude=\(longitude)&range=100") else { return }
//    
//    print(url)
//    
//    print("latitude:",String(describing: latitude)," ,longitude:",String(describing: longitude))
//    
//    let session = URLSession.shared
//    let task = session.dataTask(with: url) { (data, response, err) in
//        guard let data = data else { return }
//        do {
//            let package = try JSONDecoder().decode(Package.self, from: data)
//            //                for i in package.data.messages {
//            //                    print(package.data.messages)
//            let messages = package.data.messages
//            
//            DropManager.clearAll() // clean Drops to prevent multiple loads
//            
//            for i in messages {
//                //                    print(i)
//                let new = Drop.init(lat: CLLocationDegrees(i.latitude)!, long: CLLocationDegrees(i.longitude)!, message: i.message)
//                DropManager.add(drop: new)
//                //                    print(DropManager.drops.count)
//            }
//            //                    print()
//            //                }
//            
//        } catch let err {
//            print(err)
//        }
//    }
//    
//    performUIUpdatesOnMain{
//        let vc = MainViewController()
////        vc.tableView.reloadData()
//        vc.activityIndicator.stopAnimating()
//    }
//    
//    task.resume()
//}

