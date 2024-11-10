//
//  PlayerManager.swift
//  AudioPlayer
//
//  Created by Sonun Usubalieva on 10/11/24.
//

import MediaPlayer

protocol PlayerManagerDelegate: AnyObject {
    func didFinishPlayingTrack()
    func playerState(isOnPlay: Bool)
    func didUpdateTime(currentTime: TimeInterval, duration: TimeInterval, progress: Float)
}

final class PlayerManager {
    
    static let shared = PlayerManager()
    
    private(set) var audioPlayer: AVPlayer?
    private var currentTrack: String?
    private var timeObserverToken: Any?
    
    weak var delegate: PlayerManagerDelegate?
    
    private init() {
        setupNotificationObservers()
    }
    
    deinit {
        removeNotificationObservers()
        removePeriodicTimeObserver()
    }
    
    func playTrack(named fileName: String) {
        guard currentTrack != fileName else { return }
        
        currentTrack = fileName
        loadTrack(named: fileName)
        delegate?.playerState(isOnPlay: true)
    }
    
    func togglePlayback() {
        guard let player = audioPlayer else { return }
        
        switch player.timeControlStatus {
        case .playing:
            player.pause()
            delegate?.playerState(isOnPlay: false)
        case .paused:
            player.play()
            delegate?.playerState(isOnPlay: true)
        default:
            break
        }
    }
}

private
extension PlayerManager {
    func loadTrack(named name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            #if DEBUG
            print("Track not found: \(name)")
            #endif
            return
        }
        
        audioPlayer?.pause()
        audioPlayer = AVPlayer(url: url)
        audioPlayer?.play()
        
        addPeriodicTimeObserver()
    }
    
    func addPeriodicTimeObserver() {
        let interval = CMTime(seconds: 1, preferredTimescale: 1)
        
        timeObserverToken = audioPlayer?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self else { return }
            self.updateProgress(with: time)
        }
    }
    
    func updateProgress(with time: CMTime) {
        guard let player = audioPlayer, let currentItem = player.currentItem else { return }
        
        let currentTime = time.seconds
        let duration = currentItem.duration.seconds
        
        guard duration.isFinite else { return }
        
        let progress = Float(currentTime / duration)
        delegate?.didUpdateTime(currentTime: currentTime, duration: duration, progress: progress)
    }
        
    func removeNotificationObservers() {
        NotificationCenter.default.removeObserver(self,
                                                  name: .AVPlayerItemDidPlayToEndTime,
                                                  object: nil)
    }
    
    func removePeriodicTimeObserver() {
        if let token = timeObserverToken {
            audioPlayer?.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }
    
    func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(trackDidFinishPlaying),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: nil)
    }
}

@objc
private
extension PlayerManager {
    func trackDidFinishPlaying() {
        delegate?.didFinishPlayingTrack()
    }
}
