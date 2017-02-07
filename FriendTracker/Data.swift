//
//  Data.swift
//  FriendTracker
//
//  Created by Akapo Damilola Francis on 04/02/2017.
//  Copyright © 2017 CottaCush. All rights reserved.
//

import Foundation
import EVReflection

@objc(TrackSession)
class TrackSession: EVObject {
    var user_email: String! = "";
    var trackers: [String] = [String]();
    var is_default: Bool = false;
    var random_key: String! = "";
}

@objc(Coordinates)
class Coordinates: EVObject {
    var longitude: String! = "";
    var latitude: String! = "";
    var time: Date! = Date();
}
