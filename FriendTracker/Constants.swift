//
//  Constants.swift
//  FriendTracker
//
//  Created by Akapo Damilola Francis on 04/02/2017.
//  Copyright © 2017 CottaCush. All rights reserved.
//

import Foundation

struct Segue {
    public static let segueSetUp = "segueSetUp"
    public static let segueIsTracking = "segueIsTracking"
    public static let segueInitTracking = "segueInitTracking"
    public static let segueRestartSession = "segueRestartSession";
    
}

struct Keys {
    public static let TRACK_SESSION = "DEFAULT_TRACK_SESSION"
    public static let LOCATION = "current_location"
    public static let TRACKING_STATUS = "tracking_status"
    public static let AUTH_EMAILS = "authed_emails"
    public static let PASS_KEY = "pass_key";
}
