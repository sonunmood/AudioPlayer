//
//  SongListVM.swift
//  AudioPlayer
//
//  Created by Sonun Usubalieva on 8/11/24.
//

import Foundation
import MediaPlayer

protocol SongListVMProtocol: AnyObject {
    func loadTracks() async -> [Track]
}

class SongListVM: SongListVMProtocol {

    func loadTracks() async -> [Track] {
        let fileNames = ["a", "e", "s"]
        var tracks: [Track] = []
        
        for fileName in fileNames {
            guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else { continue }
            
            let asset = AVURLAsset(url: url)
            do {
                let metadata = try await asset.load(.metadata)
                var title: String = "Unknown bb"
                var artist: String = "Unknown bb"
                var albumName: String = "Unknown bb"

                for item in metadata {
                    guard let key = item.commonKey?.rawValue else {
                        print("No common key found")
                        continue
                    }
                    
                    switch key {
                    case "title":
                        title = try await (item.load(.value) as? String) ?? "Unknown"
                    case "artist":
                        artist = try await (item.load(.value) as? String) ?? "Unknown"
                    case "albumName":
                        albumName = try await (item.load(.value) as? String) ?? "Unknown"
                    default:
                        break
                    }
                }
                
                let track = Track(
                    title: title,
                    artist: artist,
                    albumName: albumName,
                    fileName: fileName,
                    duration: title // You might want to replace this with the actual duration
                )
                tracks.append(track)
            } catch {
                print("Error loading metadata for \(fileName): \(error)")
            }
        }
        
        return tracks
    }

}
