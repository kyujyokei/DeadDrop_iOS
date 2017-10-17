//
//  GetDataFromDB.swift
//  DeadDrop
//
//  Created by Kero on 2017/10/14.
//  Copyright © 2017年 Kei. All rights reserved.
//

import Foundation

func getDataFromDB( latitude:Float , longitude:Float , range:Float ) {
    
    //TODO: See if the Float for lat and long could be changed to CLLocationDegrees
    //TODO: Alamofire can be a useful library for networking

//    GET
//    /api/message?latitude={latitude}&longitude={longitude}&range={range}

    
    let methodParameters: [String: AnyObject] = [
        Constants.ParamKeys.latitude: latitude as AnyObject,
        Constants.ParamKeys.longitude: longitude as AnyObject,
        Constants.ParamKeys.range: range as AnyObject
        ]
    
    //print(methodParameters)
    
    let urlString = Constants.Messages.MessageBaseURL + escapedParameters(parameters: methodParameters as [String : AnyObject])
    
    print("URL:\(urlString)")
    
    let url = NSURL(string: urlString)!
    let request = NSURLRequest(url: url as URL)
    var itemArray:NSArray?
    
    
    // if an error occur, print it
    func displayError(error: String) {
        print(error)
        print("URL at time of error: \(url)")
        
    }
    
    let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
        
        if error == nil {
            if let data = data {
                let parsedResult: [String:AnyObject]!
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject] //change 16 bit JSON code to redable format
                } catch {
                    displayError(error: "Could not parse the data as JSON: '\(data)'")
                    return
                }
                
                
                
//                let itemDictionary = parsedResult![Constants.MessageResponseKeys.messages] as? [[String:AnyObject]]
                //print(itemDictionary)
                
//                
//                //grab every "title" in dictionaries by look into the array with for loop
//                for i in 0...itemDictionary!.count-1 {
//                    let itemTitle = itemDictionary![i][Constants.MerchandisesResponseKeys.MerchandiseTitle] as? String
//                    //print (itemTitle!)
//                    let itemPrice = itemDictionary![i][Constants.MerchandisesResponseKeys.MerchandisePrice] as? Int
//                    let itemId = itemDictionary![i][Constants.MerchandisesResponseKeys.MerchandiseId] as? Int
//                    let itemImage = itemDictionary![i][Constants.MerchandisesResponseKeys.image_1_s] as? String
                
                    let newDrop = Drop.init(lat: Double(Constants.MessageResponseKeys.latitude)!, long: Double(Constants.MessageResponseKeys.longitude)!, message: Constants.MessageResponseKeys.message)
                
                    DropManager.add(drop: newDrop)


                
                performUIUpdatesOnMain(){
                    // This uses the GCD Blackbox

                    let destination = MainTableViewController() as! MainTableViewController
                    destination.tableView.reloadData()
                }
            }
        }
    }
    task.resume()
}
