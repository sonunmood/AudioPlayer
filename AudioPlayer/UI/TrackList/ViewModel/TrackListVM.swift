//
//  TrackListVM.swift
//  AudioPlayer
//
//  Created by Sonun Usubalieva on 8/11/24.
//

import Foundation
import MediaPlayer

protocol TrackListVMProtocol: AnyObject {
    func getTracks() -> [Track]
    func getTrack(_ by: Int) -> Track?
}

class TrackListVM: TrackListVMProtocol {
    private var tracks: [Track] = [
        .init(artist: "Don Toliver", trackName: "What you need", fileName: "unknown", duration: "3:14"),
        .init(artist: "Sadraddin", trackName: "Peaky Peaky", fileName: "unknown2", duration: "2:45"),
        .init(artist: "Eminem", trackName: "Mockingbird", fileName: "unknown3", duration: "4:11"),
    ]
    
    func getTracks() -> [Track] {
        tracks
    }
    
    func getTrack(_ by: Int) -> Track? {
        tracks.count > by ? tracks[by] : nil
    }
}
