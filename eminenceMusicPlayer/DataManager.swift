//
//  DataManager.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 1/22/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import Foundation

class DataManager {
    
    var unknownArtists: [String] {
        get {
            if UserDefaults.standard.array(forKey: "UnknownArtists") == nil {
                UserDefaults.standard.set([String](), forKey: "UnknownArtists")
            }
            
            return UserDefaults.standard.array(forKey: "UnknownArtists") as! [String]
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "UnknownArtists")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    var artistData: [String:[String:String]] {
        get {
            if UserDefaults.standard.dictionary(forKey: "ArtistData") == nil {
                UserDefaults.standard.set([String:[String:String]](), forKey: "ArtistData")
            }
            
            return UserDefaults.standard.dictionary(forKey: "ArtistData") as! [String : [String : String]]
        }
    }
    
    func setArtistData(key: String, value: [String:String]) {
        guard UserDefaults.standard.array(forKey: "ArtistData") != nil else { return }
        
        print("passed guard");
        var data = artistData
        data[key] = value
        
        UserDefaults.standard.set([data], forKey: "ArtistData")
        UserDefaults.standard.synchronize()
    }
    
    func dataForArtist(persistentId: UInt64) -> [String:String]? {
        return artistData["\(persistentId)"]
    }
    
    
    
}
