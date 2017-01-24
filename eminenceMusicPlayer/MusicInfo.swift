//
//  MusicInfo.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 1/22/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import Foundation

class MusicInfo {
    static let shared = MusicInfo()
    
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
        
        var data = artistData
        data[key] = value
        
        UserDefaults.standard.set([data], forKey: "ArtistData")
        
    }
    
    func dataForArtist(persistentId: UInt64) -> [String:String]? {
        return artistData["\(persistentId)"]
    }
    

    
}
