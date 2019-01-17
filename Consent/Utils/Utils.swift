//
//  Utils.swift
//  Aux Plz
//
//  Created by Shahar Ben-Dor on 1/3/19.
//  Copyright © 2019 Spectre. All rights reserved.
//

import Foundation

class Utils {
    static func runAsyncTask(dispatchGroup: DispatchGroup, targetTaskCount: Int, completedTaskCount: inout Int) {
        completedTaskCount += 1
        if completedTaskCount >= targetTaskCount {
            dispatchGroup.leave()
        }
    }
    
    static func isSimulator() -> Bool {
        #if targetEnvironment(simulator)
            return true
        #else
            return false
        #endif
    }
}
