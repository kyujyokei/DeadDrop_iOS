//
//  GCDBlackBox.swift
//  DeadDrop
//
//  Created by Kero on 2017/10/14.
//  Copyright © 2017年 Kei. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
