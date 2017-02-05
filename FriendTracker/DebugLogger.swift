//
//  DebugLogger.swift
//  FriendTracker
//
//  Created by Akapo Damilola Francis on 04/02/2017.
//  Copyright © 2017 CottaCush. All rights reserved.
//

import Foundation

struct LogMinx {
    static let state: Bool = false;
    static func logData(string: String){
        if(state == true){
            debugPrint(string);
        }
    }
    
    static func logData(string: AnyObject){
        if(state == true){
            debugPrint(string);
        }
    }
}
