//
//  PlayerView.swift
//  Example
//
//  Created by Moayad Al kouz on 8/13/18.
//  Copyright © 2018 Moayad Al kouz. All rights reserved.
//

import UIKit
import youtube_ios_player_helper_swift
import YouTubePlayer

class PlayerView: UIView {
    var videoId: String = "" {
        didSet{
            if !videoId.isEmpty{
                loadVideo()
            }
        }
    }
    
    @IBOutlet weak var ytPlayerView: YTPlayerView!
    @IBOutlet weak var Youtube: YouTubePlayerView!
    @IBOutlet weak var btnPlayPause: UIButton!
    @IBOutlet weak var fullscreenButton: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var controlsView: UIView!
    @IBOutlet weak var tapView: UIView!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    
    var rootVC: YouTubeListVC!
    
    private var isFullScreen = false
    private var timer: Timer?
    private var tapGestureRecognizer: UITapGestureRecognizer!
    private var audioDuration: Double!
    
    private func loadVideo(){
        print("loadVideo")
        let playerVars:[String: Any] = [
            "controls" : "0",
            "rel": "0",
            "iv_load_policy" : "3",
            "playsinline" : "1"
        ]
        ytPlayerView.delegate = self
        _ = ytPlayerView.load(videoId: videoId, playerVars: playerVars)
        ytPlayerView.isUserInteractionEnabled = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(setAnimation))
        controlsView.addGestureRecognizer(tap)
        tapView.addGestureRecognizer(tap)
        tapView.isHidden = true
        audioDuration = 0
        tapGestureRecognizer = UITapGestureRecognizer(target: nil, action: nil)
        
        btnPlayPause.setIconImage(imageName: "play-button-3")
        fullscreenButton.setIconImage(imageName: "switch-to-full-screen-button")
        currentTimeLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        currentTimeLabel.setTime(time: 0)
        remainingTimeLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        remainingTimeLabel.setTime(time: 0)
        timeSlider.setCircle()
    }
    
    @objc func sliderTapped(gestureRecognizer: UIGestureRecognizer) {
        let pointTapped: CGPoint = gestureRecognizer.location(in: self)
        let positionOfSlider: CGPoint = timeSlider.frame.origin
        let widthOfSlider: CGFloat = timeSlider.frame.size.width
        let newValue = (pointTapped.x - positionOfSlider.x) * CGFloat(timeSlider.maximumValue) / widthOfSlider
        let double = audioDuration * Double(newValue)
        ytPlayerView.seek(seekToSeconds: Float(double), allowSeekAhead: true)
        self.timeSlider.value = Float(double / audioDuration)
        if ytPlayerView.playerState == .paused {
            ytPlayerView.playVideo()
            btnPlayPause.setIconImage(imageName: "rounded-pause-button")
        }
    }
    
    @IBAction func toggleFullScreen(_ sender: Any) {
        isFullScreen = !isFullScreen
        if isFullScreen{
            rootVC.landscape()
            leftConstraint.constant = 40
            rightConstraint.constant = 40
        } else {
            rootVC.portrait()
            leftConstraint.constant = 20
            rightConstraint.constant = 8
        }
    }
    
    @IBAction func inside(_ sender: Any) {
        let double = audioDuration * Double(timeSlider.value)
        ytPlayerView.seek(seekToSeconds: Float(double), allowSeekAhead: true)
        if ytPlayerView.playerState == .paused {
            ytPlayerView.playVideo()
            btnPlayPause.setIconImage(imageName: "rounded-pause-button")
        }
        tapGestureRecognizer.isEnabled = true
    }
    
    @IBAction func outside(_ sender: Any) {
        tapGestureRecognizer.isEnabled = false
    }
    
    @IBAction func playStop(sender: UIButton){
        if ytPlayerView.playerState == .playing{
            ytPlayerView.pauseVideo()
            btnPlayPause.setIconImage(imageName: "play-button-3")
        }else{
            ytPlayerView.playVideo()
            btnPlayPause.setIconImage(imageName: "rounded-pause-button")
        }
        setAnimation()
    }
    
    @objc private func setAnimation() {
        //print("setAnimation")
        controlsView.alpha = 1
        tapView.isHidden = true
        self.controlsView.layer.removeAllAnimations()
        if timer != nil {
            timer?.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(startAnimation), userInfo: nil, repeats: false)
    }
    
    @objc private func startAnimation() {
        if !self.timeSlider.isTouchInside {
            //print("startAnimation")
            tapView.isHidden = false
            UIView.animate(withDuration: 1, animations: {
                self.controlsView.alpha = 0
            }, completion: nil)
        }
    }
}

extension PlayerView: YTPlayerViewDelegate{
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        print("playerView playerViewDidBecomeReady \(ytPlayerView.duration)")
        audioDuration = Double(ytPlayerView.duration)
        remainingTimeLabel.setTime(time: audioDuration)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sliderTapped(gestureRecognizer:)))
        self.timeSlider.addGestureRecognizer(tapGestureRecognizer)
        playerView.playVideo()
        btnPlayPause.setIconImage(imageName: "rounded-pause-button")
        setAnimation()
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo quality: YTPlaybackQuality) {
        print("Quality :: ", quality)
    }
    
    func playerView(_ playerView: YTPlayerView, didPlayTime playTime: Float){
        if !self.timeSlider.isTouchInside {
            self.timeSlider.value = playTime / Float(ytPlayerView.duration)
            self.currentTimeLabel.setTime(time: Double(playTime))
        }
    }
}
