//
//  PodcastVC.swift
//  Kinoogon
//
//  Created by Sultan Karybaev on 11/23/18.
//  Copyright © 2018 Sultan Karybaev. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import FirebaseStorage
//import AudioPlayer

protocol PodcastDelegate {
    func rollPodcast()
    func closePodcast()
}

class PodcastVC: UIViewController {

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var imageSize: NSLayoutConstraint!
    @IBOutlet weak var mainImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainImageCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var sliderLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var sliderTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var sliderCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var closeButtonViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var playButtonViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var closeButtonViewWidthContraint: NSLayoutConstraint!
    @IBOutlet weak var podcastNameLabel: UILabel!
    @IBOutlet weak var podcastNameLabelCenterYConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var closeButtonRolled: UIButton!
    @IBOutlet weak var playButtonRolled: UIButton!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationTimeLabel: UILabel!
    @IBOutlet weak var timeStackView: UIStackView!
    
    var player: AVPlayer!
    var asset: AVURLAsset!
    var audioDuration: CMTime?
    var audioDurationSeconds: Float64!
    var tapGestureRecognizer: UITapGestureRecognizer!
    public var podcastName: String = "Music Music Music Music Music Music Music Music Music Music Music Music"
    
    var audioPlayer: AVAudioPlayer!
    
    public var delegate: PodcastDelegate?
    
    override func viewDidLoad() {
        print("viewDidLoad PodcastVC")
        super.viewDidLoad()
        Player.instance.delegate = self
        self.setNavigationBackButton()
        self.setLayer()
        currentTimeLabel.setTime(time: 0)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sliderTapped(gestureRecognizer:)))
        self.slider.addGestureRecognizer(tapGestureRecognizer)
        
        imageSize.constant = view.frame.height * 0.3
        mainImageHeightConstraint.constant = view.frame.height * 0.3
        
        setPlayPauseImage(imageName: "rounded-pause-button", littleImageName: "music-player-pause-lines")
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        slider.setCircle()
        
        let fire = "https://firebasestorage.googleapis.com/v0/b/kinoogon-85687.appspot.com/o/podcasts%2F2019-01-04%2011.19.06.mp3?alt=media&token=4ffff425-38b0-48ef-9cce-939d45fe693e"
        //self.playerPlay(url: fire)
        
        
        
        Storage.storage().reference().child("[BadComedian] - Ёлки 666 (НОВЫЙ ГОД В АДУ).mp4").downloadURL { (url, error) in
            if let error = error {
                debugPrint("PodcastVC.swift \(error.localizedDescription)")
            } else {
                //print("111111111111111111111 \(url)")
                //self.playerPlay(url: url!)
                
                //self.playerPlay(url: NSURL(string: vk) as! URL)
            }
        }
    }
    
    private func setLayer() {
        let closeIcon = UIImage(named: "cancel-music")?.withRenderingMode(.alwaysTemplate)
        closeButtonRolled.setImage(closeIcon, for: .normal)
        closeButtonRolled.imageView?.contentMode = .scaleAspectFit
        closeButtonRolled.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        podcastNameLabel.text = self.podcastName
    }
    
    @objc func playerDidFinishPlaying() {
        Player.instance.seek(time: CMTime(seconds: 0, preferredTimescale: 1))
        Player.instance.pause()
        setPlayPauseImage(imageName: "play-button-3", littleImageName: "music-player-play")
    }
    
    @objc func sliderTapped(gestureRecognizer: UIGestureRecognizer) {
        print("sliderTapped")
        Player.instance.pause()
        let pointTapped: CGPoint = gestureRecognizer.location(in: self.view)
        let positionOfSlider: CGPoint = slider.frame.origin
        let widthOfSlider: CGFloat = slider.frame.size.width
        let newValue = (pointTapped.x - positionOfSlider.x) * CGFloat(slider.maximumValue) / widthOfSlider
        guard let seconds = audioDuration?.seconds else { return }
        let double = seconds * Double(newValue)
        Player.instance.seek(time: CMTime(seconds: double, preferredTimescale: 1))
    }
    
    @IBAction func inside(_ sender: Any) {
        print("inside")
        Player.instance.pause()
        guard let seconds = audioDuration?.seconds else { return }
        let double = seconds * Double(slider.value)
        Player.instance.seek(time: CMTime(seconds: double, preferredTimescale: 1))
        tapGestureRecognizer.isEnabled = true
    }
    
    @IBAction func outside(_ sender: Any) {
        print("outside")
        tapGestureRecognizer.isEnabled = false
    }
    
    @IBAction func togglePlayPause(_ sender: Any) {
        if Player.instance.rate == 0 {
            Player.instance.play()
        } else {
            Player.instance.pause()
        }
    }
    
    @IBAction func closeButtonWasPressed(_ sender: Any) {
        delegate?.closePodcast()
    }
    
    private func setPlayPauseImage(imageName: String, littleImageName: String) {
        let icon = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        playButton.setImage(icon, for: .normal)
        playButton.imageView?.contentMode = .scaleAspectFit
        playButton.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let littleIcon = UIImage(named: littleImageName)?.withRenderingMode(.alwaysTemplate)
        playButtonRolled.setImage(littleIcon, for: .normal)
        playButtonRolled.imageView?.contentMode = .scaleAspectFit
        playButtonRolled.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    private func setNavigationBackButton() {
        title = self.podcastName
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let textAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        let backImage = UIImage(named: "left-arrow-4")
        let barBackImage = UIBarButtonItem.init(image: backImage, style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = barBackImage
        navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    @objc func backButtonTapped() {
        delegate?.rollPodcast()
    }
    
    private func playerPlay(url: String) {
        Player.instance.url = url
        DispatchQueue.global().async {
            self.asset = AVURLAsset(url: URL(string: url)!, options: nil)
            self.audioDuration = self.asset.duration
            self.audioDurationSeconds = CMTimeGetSeconds(self.asset.duration)
            Player.instance.add(observer: { time in
                if !self.slider.isTouchInside {
                    self.slider.value = Float(time.seconds / self.asset.duration.seconds)
                    self.currentTimeLabel.setTime(time: time.seconds)
                }
            })
            DispatchQueue.main.async {
                self.durationTimeLabel.setTime(time: Double(self.audioDurationSeconds))
            }
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        DispatchQueue.global().async {
            Player.instance.stop()
        }
        
    }
}

extension PodcastVC: PlayerDelegate {
    func pause() {
        setPlayPauseImage(imageName: "play-button-3", littleImageName: "music-player-play")
    }
    
    func play() {
        setPlayPauseImage(imageName: "rounded-pause-button", littleImageName: "music-player-pause-lines")
    }
    
    
}


