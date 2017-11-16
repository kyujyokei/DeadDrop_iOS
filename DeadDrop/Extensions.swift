//
//  Extensions.swift
//  DeadDrop
//
//  Created by Kero on 2017/11/15.
//  Copyright © 2017年 Kei. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    func addContraintWothFormat(format:String, views:UIView...){
        var viewDictionary = [String:UIView]()
        for(index, view) in views.enumerated(){
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewDictionary))
    }
    
}
