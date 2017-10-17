//
//  escapeParameters.swift
//  DeadDrop
//
//  Created by Kero on 2017/10/14.
//  Copyright © 2017年 Kei. All rights reserved.
//

import Foundation
import UIKit

func escapedParameters(parameters: [String:AnyObject]) -> String {
    if parameters.isEmpty {
        return ""
    } else {
        var keyValurPairs = [String]()
        
        for (key, value) in parameters {
            
            // make sure it is a string value (convert the ones aren't)
            let stringValue = "\(value)"
            
            //escape it
            let escapeValue = stringValue.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            //convert string to ASCII compliant version of a string, returns characters considered safe ASCIIs only
            
            //append it
            keyValurPairs.append(key + "=" + "\(escapeValue!)")
            
        }
        return "?\(keyValurPairs.joined(separator: "&"))"
    }
    
}
