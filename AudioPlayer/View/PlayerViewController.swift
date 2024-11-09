class PlayerViewController: UIViewController {
    private let track: Track
    private var currentIndex: Int
    private let tracks: [Track]
    private var audioPlayer: AVAudioPlayer?
    
    private let titleLabel = UILabel()
    private let artistLabel = UILabel()
    private let progressSlider = UISlider()
    private let playPauseButton = UIButton()
    private let nextButton = UIButton()
    private let prevButton = UIButton()
    
    init(track: Track, tracks: [Track], initialIndex: Int) {
        self.track = track
        self.tracks = tracks
        self.currentIndex = initialIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAudioPlayer()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        titleLabel.text = track.title
        artistLabel.text = track.artist
        
        // Configure buttons
        playPauseButton.setTitle("Play", for: .normal)
        playPauseButton.addTarget(self, action: #selector(playPauseTapped), for: .touchUpInside)
        
        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        
        prevButton.setTitle("Previous", for: .normal)
        prevButton.addTarget(self, action: #selector(prevTapped), for: .touchUpInside)
        
        // Add subviews
        let stackView = UIStackView(arrangedSubviews: [prevButton, playPauseButton, nextButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupAudioPlayer() {
        guard let url = Bundle.main.url(forResource: track.fileName, withExtension: "mp3") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
        } catch {
            print("Error loading audio: \(error)")
        }
    }
    
    @objc private func playPauseTapped() {
        guard let player = audioPlayer else { return }
        if player.isPlaying {
            player.pause()
            playPauseButton.setTitle("Play", for: .normal)
        } else {
            player.play()
            playPauseButton.setTitle("Pause", for: .normal)
        }
    }
    
    @objc private func nextTapped() {
        currentIndex = (currentIndex + 1) % tracks.count
        updateTrack()
    }
    
    @objc private func prevTapped() {
        currentIndex = (currentIndex - 1 + tracks.count) % tracks.count
        updateTrack()
    }
    
    private func updateTrack() {
        let newTrack = tracks[currentIndex]
        titleLabel.text = newTrack.title
        artistLabel.text = newTrack.artist
        setupAudioPlayer()
        playPauseTapped()
    }
}