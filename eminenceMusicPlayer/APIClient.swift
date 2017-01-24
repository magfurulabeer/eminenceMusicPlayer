//
//  APIClient.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 1/22/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import Foundation
import MediaPlayer
import CoreData

class APIClient {
    // I'm making this public. Please don't steal.
    fileprivate var apiKey = "f3e873031de88070049402c6d5bf103a"
    let baseURL = "http://ws.audioscrobbler.com/2.0/"
    let musicManager = MusicManager.sharedManager
    static let shared = APIClient()
    
    var unexploredArtists = [MPMediaItemCollection]()
    var unknownArtists = UserDefaults.standard.array(forKey: "ArtistsWithNoInformation") ?? [String]() {
        didSet {
            print("DID SET")
            UserDefaults.standard.set(unknownArtists, forKey: "ArtistsWithNoInformation")
            UserDefaults.standard.synchronize()
        }
    }
    
    func getArtistData(artistName: String, persistentId: UInt64) {
        print("getting artist \(artistName)")
        
        // TODO: Figure out how to trim other characters like umlauts
        let name = artistName.replacingOccurrences(of: " ", with: "")
        
        let urlComponent = "?method=artist.getinfo&artist=\(name)&format=json"
        let urlString = baseURL + urlComponent + "&api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print(urlString)
            self.unexploredArtists.removeFirst()
            self.downloadArtistData()
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            
            guard error == nil  else {
                print(error?.localizedDescription)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("WARNING: URL Response is not an HTTP Response.")
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                print("Status code: (\(httpResponse.statusCode))")
                
//                if httpResponse.statusCode == 404 {
//                    var updatedUnknowns = self.dataManager.unknownArtists
//                    updatedUnknowns.append("\(persistentId)")
//                    self.dataManager.unknownArtists = updatedUnknowns
//                }
                return
            }
            
            guard let data = data else { return }

            let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
            
            guard let json = jsonData as? [String : Any] else { return }

            let _ = self.saveArtistData(json: json, persistentId: persistentId)
                

            self.unexploredArtists.removeFirst()
            self.downloadArtistData()
        }
        
        task.resume()
    }
    
    func saveArtistData(json: [String : Any], persistentId: UInt64) -> Bool {
        guard let artistData = json["artist"] as? [String: Any] else {
            if let error = json["error"] as? Int {
                if error == 6 {
                    print("Adding \(persistentId) to Unknown Artists")
                    var unknowns = unknownArtists
                    unknowns.append("\(persistentId)")
                    unknownArtists = unknowns
                }
            }
            return false
        }
        
        let artistBio = artistData["bio"] as? [String: Any]
        
        let artistSummary = artistBio?["summary"]
        imageDictionaryExists: if let artistImageArray = artistData["image"] as? [[String:String]] {
            let imageDictionary = artistImageArray[3]
            
            guard let imageURL = imageDictionary["#text"] else { break imageDictionaryExists }
            
            guard let url = URL(string: imageURL) else { break imageDictionaryExists }
            
            
            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                guard let data = data else { return }
                guard let image = UIImage(data: data) else { return }
                
                if let data = UIImagePNGRepresentation(image) {
                    let filename = getDocumentsDirectory().appendingPathComponent("\(persistentId).png")
                    try? data.write(to: filename)
                }
            })
            
            task.resume()
        
        }
        
        guard let summary = artistSummary as? String else {
            return false
        }
        
//        print("GUARD SUMMARY PASSED")
        
        let artist = EMArtist(context: self.musicManager.persistentContainer.viewContext)
        artist.id = "\(persistentId)"
        artist.summary = summary
        
        
        OperationQueue.main.addOperation {
            self.musicManager.saveContext()
        }
        
        return true
    }
    
    func checkForUnexploredArtists() {
//        for artistCollection in musicManager.artistList {
//            self.unexploredArtists.append(artistCollection)
//        }

        let artistFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EMArtist")
        do {
            let fetchedArtists = try musicManager.persistentContainer.viewContext.fetch(artistFetchRequest)
            
            for artistCollection in musicManager.artistList {
                guard let id = artistCollection.representativeItem?.artistPersistentID else {
                    continue
                }
                
                let isSaved = fetchedArtists.contains(where: { (artist) -> Bool in
                    if let artist = artist as? EMArtist {

                        return artist.id! == "\(id)"
                    } else {
                        return false
                    }
                })
                
                if !isSaved {
                    let noInfoArray = UserDefaults.standard.array(forKey: "ArtistsWithNoInformation") as! [String]
                    if !noInfoArray.contains("\(id)") {
                        print("Added Artist")
                        self.unexploredArtists.append(artistCollection)
                    }
                    
                }
                
            }
        } catch {
            print("Unable to fetch EMArtists")
        }
        
        
    }
    
    func downloadArtistData() {
        guard let artist = unexploredArtists.first else { return }
        
        let id = artist.representativeItem?.artistPersistentID
        

        guard id != nil else { return }

        let artistName = artist.representativeItem?.artist ?? ""
        

        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            print("Background thread")
            if artistName != "" {
                print("if")
                self.getArtistData(artistName: artistName, persistentId: artist.representativeItem!.artistPersistentID)
            } else {
                print("else")
                self.unexploredArtists.removeFirst()
                self.downloadArtistData()
            }
        }
    }
    
}
