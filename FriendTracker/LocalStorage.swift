//
//  LocalStorage.swift
//  FriendTracker
//
//  Created by Akapo Damilola Francis on 04/02/2017.
//  Copyright © 2017 CottaCush. All rights reserved.
//

import Foundation

class LocalStorage{
    init() {
    }
    
    static public func getInstance() -> LocalStorage {
        return LocalStorage()
    }
    
    public func persistString(string: String!, key: String!){
        delete(key: key);
        UserDefaults.standard.setValue(string, forKey: key);
        UserDefaults.standard.synchronize();
    }
    
    public func getDefaultTrackingSession() -> TrackSession? {
        let string = getString(key: Keys.TRACK_SESSION);
        if (string != nil) {
            return TrackSession(json: string);
        }
        return  nil;
    }
    
    public func getString(key: String!) -> String? {
        UserDefaults.standard.synchronize()
        return UserDefaults.standard.value(forKey: key) as? String;
    }
    
    public func delete(key: String!){
        UserDefaults.standard.removeObject(forKey: key);
        UserDefaults.standard.synchronize();
    }
    
    
    public func clearAll(){
        let appDomain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
        UserDefaults.standard.synchronize()
    }
}
