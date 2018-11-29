//
//  PodcastVC.swift
//  Kinoogon
//
//  Created by Sultan Karybaev on 11/23/18.
//  Copyright © 2018 Sultan Karybaev. All rights reserved.
//

import UIKit
import AVFoundation

class PodcastVC: UIViewController {

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var imageSize: NSLayoutConstraint!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationTimeLabel: UILabel!
    
    var player: AVPlayer!
    let music = Bundle.main.path(forResource: "Blue - Curtain Falls", ofType: "mp3")!
    let video = Bundle.main.path(forResource: "video", ofType: "mp4")!
    var asset: AVURLAsset!
    var audioDuration: CMTime!
    var audioDurationSeconds: Float64!
    var tapGestureRecognizer: UITapGestureRecognizer!
    let youtube = "https://www.youtube.com/watch?v=YrlS5BUrhdY"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBackButton()
        asset = AVURLAsset(url: NSURL.fileURL(withPath: video), options: nil)
        audioDuration = asset.duration
        audioDurationSeconds = CMTimeGetSeconds(audioDuration)
        durationTimeLabel.setTime(time: Double(audioDurationSeconds))
        currentTimeLabel.setTime(time: 0)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sliderTapped(gestureRecognizer:)))
        self.slider.addGestureRecognizer(tapGestureRecognizer)
        
        imageSize.constant = view.frame.height * 0.3
        
        setPlayPauseImage(imageName: "rounded-pause-button")
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        slider.setCircle()
    }
    
    @objc func playerDidFinishPlaying() {
        print("Video Finished")
        player.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
        setPlayPauseImage(imageName: "play-button-3")
    }
    
    @objc func sliderTapped(gestureRecognizer: UIGestureRecognizer) {
        let pointTapped: CGPoint = gestureRecognizer.location(in: self.view)
        let positionOfSlider: CGPoint = slider.frame.origin
        let widthOfSlider: CGFloat = slider.frame.size.width
        let newValue = (pointTapped.x - positionOfSlider.x) * CGFloat(slider.maximumValue) / widthOfSlider
        let double = audioDuration.seconds * Double(newValue)
        player.seek(to: CMTime(seconds: double, preferredTimescale: 1))
        if player.rate == 0 {
            player.play()
            setPlayPauseImage(imageName: "rounded-pause-button")
        }
    }
    
    @IBAction func inside(_ sender: Any) {
        let double = audioDuration.seconds * Double(slider.value)
        player.seek(to: CMTime(seconds: double, preferredTimescale: 1))
        if player.rate == 0 {
            player.play()
            setPlayPauseImage(imageName: "rounded-pause-button")
        }
        tapGestureRecognizer.isEnabled = true
    }
    
    @IBAction func outside(_ sender: Any) {
        tapGestureRecognizer.isEnabled = false
    }
    
    @IBAction func togglePlayPause(_ sender: Any) {
        if player.rate == 0 {
            player.play()
            setPlayPauseImage(imageName: "rounded-pause-button")
        } else {
            player.pause()
            setPlayPauseImage(imageName: "play-button-3")
        }
    }
    
    private func setPlayPauseImage(imageName: String) {
        let icon = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        playButton.setImage(icon, for: .normal)
        playButton.imageView?.contentMode = .scaleAspectFit
        playButton.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    private func setNavigationBackButton() {
        title = "Music Music Music Music Music Music Music Music Music Music Music Music"
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let textAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        let backImage = UIImage(named: "left-arrow-4")
        let barBackImage = UIBarButtonItem.init(image: backImage, style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = barBackImage
        navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    @objc func backButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player = AVPlayer(url: NSURL.fileURL(withPath: video))
        player.play()
        let interval = CMTimeMake(value: 1, timescale: 4)
        // Менять показатели слайдера по ходу проигрывания
        player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { time in
            if !self.slider.isTouchInside {
                self.slider.value = Float(time.seconds / self.audioDuration.seconds)
                self.currentTimeLabel.setTime(time: time.seconds)
            }
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player.replaceCurrentItem(with: nil)
    }
    
    private func setupPlayer(with asset: AVAsset) {
        player.replaceCurrentItem(with: AVPlayerItem(asset: asset))
        player.play()
    }
    
}


