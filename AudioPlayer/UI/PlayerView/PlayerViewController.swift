//
//  PlayerViewController.swift
//  AudioPlayer
//
//  Created by Sonun Usubalieva on 9/11/24.
//

import UIKit
import MediaPlayer

final class PlayerViewController: UIViewController {
    
    static let shared = PlayerViewController()
    
    private lazy var closebtn: UIButton = {
        let btn = UIButton()
        btn.setImage(.icClose, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    private lazy var logoIV: UIImageView = {
        let iv = UIImageView()
        iv.image = .icLogo
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        return iv
    }()
    
    private lazy var nameLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 18, weight: .bold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    private lazy var trackNameLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.numberOfLines = 3
        lbl.font = .systemFont(ofSize: 18, weight: .medium)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    private lazy var timeLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "0:00"
        lbl.textColor = .white
        lbl.textAlignment = .left
        lbl.font = .systemFont(ofSize: 12, weight: .medium)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    private lazy var durationLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "0:00"
        lbl.textColor = .white
        lbl.textAlignment = .right
        lbl.font = .systemFont(ofSize: 12, weight: .medium)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    private lazy var duretionSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        return slider
    }()
    
    private lazy var playPauseBtn: UIImageView = {
        let btn = UIImageView()
        btn.isUserInteractionEnabled = true
        btn.image = .icPause
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    private lazy var nextBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(.icNext, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    private lazy var previousBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(.icPrevious, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
        
    private(set) var trackIndex: Int = 0
    private(set) var tracks: [Track] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        PlayerManager.shared.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        previousBtn.isEnabled = trackIndex != 0
    }
    
    func resetState(with tracks: [Track], startingAt index: Int) {
        self.tracks = tracks
        playTrack(at: index)
    }
}

private
extension PlayerViewController {
    func addSubviews(){
        view.backgroundColor = .black
        view.addSubviews(
            closebtn,
            playPauseBtn,
            nextBtn,
            previousBtn,
            duretionSlider,
            timeLbl,
            durationLbl,
            trackNameLbl,
            nameLbl,
            logoIV
        )
        
        setConstr()
        addTargets()
    }
    
    func setConstr(){
        NSLayoutConstraint.activate([
            closebtn.heightAnchor.constraint(equalToConstant: 24),
            closebtn.widthAnchor.constraint(equalToConstant: 24),
            closebtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            closebtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            
            playPauseBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playPauseBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            playPauseBtn.heightAnchor.constraint(equalToConstant: 32),
            playPauseBtn.widthAnchor.constraint(equalToConstant: 32),
            
            nextBtn.leftAnchor.constraint(equalTo: playPauseBtn.rightAnchor, constant: 40),
            nextBtn.centerYAnchor.constraint(equalTo: playPauseBtn.centerYAnchor),
            nextBtn.heightAnchor.constraint(equalToConstant: 32),
            nextBtn.widthAnchor.constraint(equalToConstant: 32),
            
            previousBtn.rightAnchor.constraint(equalTo: playPauseBtn.leftAnchor, constant: -40),
            previousBtn.widthAnchor.constraint(equalToConstant: 32),
            previousBtn.heightAnchor.constraint(equalToConstant: 32),
            previousBtn.centerYAnchor.constraint(equalTo: playPauseBtn.centerYAnchor),
            
            duretionSlider.bottomAnchor.constraint(equalTo: playPauseBtn.topAnchor, constant: -20),
            duretionSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            duretionSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            timeLbl.bottomAnchor.constraint(equalTo: duretionSlider.topAnchor, constant: -20),
            timeLbl.leadingAnchor.constraint(equalTo: duretionSlider.leadingAnchor),
            
            durationLbl.centerYAnchor.constraint(equalTo: timeLbl.centerYAnchor),
            durationLbl.trailingAnchor.constraint(equalTo: duretionSlider.trailingAnchor),
            
            trackNameLbl.bottomAnchor.constraint(equalTo: durationLbl.topAnchor,constant: -24),
            trackNameLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackNameLbl.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -16),
            trackNameLbl.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 16),
            
            nameLbl.bottomAnchor.constraint(equalTo: trackNameLbl.topAnchor,constant: -8),
            nameLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackNameLbl.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -16),
            trackNameLbl.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 16),
            
            logoIV.bottomAnchor.constraint(equalTo: nameLbl.topAnchor, constant: -24),
            logoIV.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoIV.heightAnchor.constraint(equalToConstant: 200),
            logoIV.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -16),
            logoIV.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 16),
        ])
    }
    
    func addTargets(){
        playPauseBtn.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(playPauseTapped)))
        duretionSlider.addTarget(
            self,action: #selector(sliderValueChanged), for: .valueChanged)
        nextBtn.addTarget(self,
                          action: #selector(nextButtonTapped), for: .touchUpInside)
        previousBtn.addTarget(self,
                              action: #selector(previousButtonTapped), for: .touchUpInside)
        closebtn.addTarget(self,
                           action: #selector(didTapCloseBtn), for: .touchUpInside)
    }
    
    func playTrack(at index: Int) {
        guard index >= 0, index < tracks.count else { return }
        trackIndex = index
        let fileName = tracks[trackIndex].fileName
        PlayerManager.shared.playTrack(named: fileName)
        setData()
    }
    
    func setData() {
        let data = tracks[trackIndex]
        nameLbl.text = data.artist
        trackNameLbl.text = data.trackName
    }
}

@objc
private
extension PlayerViewController {
    func didTapCloseBtn() {
        self.dismiss(animated: true)
    }
    
    func playPauseTapped() {
        PlayerManager.shared.togglePlayback()
    }
    
    func nextButtonTapped() {
        if trackIndex < tracks.count - 1 {
            trackIndex += 1
            let fileName = tracks[trackIndex].fileName
            PlayerManager.shared.playTrack(named: fileName)
            previousBtn.isEnabled = true
        } else {
            trackIndex = 0
            let fileName = tracks[trackIndex].fileName
            PlayerManager.shared.playTrack(named: fileName)
            previousBtn.isEnabled = false
        }
        setData()
    }
    
    func previousButtonTapped() {
        if trackIndex > 0 {
            trackIndex -= 1
            let fileName = tracks[trackIndex].fileName
            PlayerManager.shared.playTrack(named: fileName)
            previousBtn.isEnabled = trackIndex != 0
        }
        setData()
    }
    
    func sliderValueChanged(_ sender: UISlider) {
        guard let player = PlayerManager.shared.audioPlayer else { return }
        let targetTime = CMTime(
            seconds: Double(sender.value) * (player.currentItem?.duration.seconds ?? 0),
            preferredTimescale: 1
        )

        DispatchQueue.main.async {
            player.seek(to: targetTime) { _ in
                #if DEBUG
                print("Seek operation completed.")
                #endif
            }
        }
    }
}

extension PlayerViewController: PlayerManagerDelegate {
    func playerState(isOnPlay: Bool) {
        playPauseBtn.image = isOnPlay ? .icPause : .icPlay
    }

    func didFinishPlayingTrack() {
        nextButtonTapped()
    }
    
    func didUpdateTime(currentTime: TimeInterval,
                       duration: TimeInterval,
                       progress: Float) {
        duretionSlider.value = progress
        let currentMinutes = Int(currentTime) / 60
        let currentSeconds = Int(currentTime) % 60
        timeLbl.text = String(format: "%d:%02d", currentMinutes, currentSeconds)
        
        let durationMinutes = Int(duration) / 60
        let durationSeconds = Int(duration) % 60
        durationLbl.text = String(format: "%d:%02d", durationMinutes, durationSeconds)
    }
}
