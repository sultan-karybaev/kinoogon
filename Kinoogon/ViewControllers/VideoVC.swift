//
//  VideoVC.swift
//  Kinoogon
//
//  Created by Sultan Karybaev on 3/12/19.
//  Copyright © 2019 Sultan Karybaev. All rights reserved.
//

import UIKit
import AVFoundation

class VideoVC: UIViewController {

    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var slider: UISlider!
    
    private var tapGestureRecognizer: UITapGestureRecognizer!
    private var dragSliderAllowed: Bool = true
    private var isSliderTapped: Bool = true
    private var durationTest = 58
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let playerLayer = Player.instance.playerLayer
//        playerLayer.frame = view.bounds
//        print("setPlayerLayer \(playerLayer.frame)")
//        view.layer.addSublayer(playerLayer)
        Player.instance.delegate = self
        self.slider.setCircle()
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sliderTapped(gestureRecognizer:)))
        self.slider.addGestureRecognizer(tapGestureRecognizer)
        setVideo()
    }
    
    @objc func sliderTapped(gestureRecognizer: UITapGestureRecognizer) {
        print("sliderTapped ---------------------------------------------")
        self.isSliderTapped = true
        Player.instance.pause()
        let pointTapped: CGPoint = gestureRecognizer.location(ofTouch: 0, in: self.sliderView)
        let positionOfSlider: CGPoint = slider.frame.origin
        let widthOfSlider: CGFloat = slider.frame.size.width
        let newValue = (pointTapped.x - positionOfSlider.x) * CGFloat(slider.maximumValue) / widthOfSlider
        //guard let seconds = audioDuration?.seconds else { return }
        let seconds = Double(durationTest)
        let double = seconds * Double(newValue)
        self.slider.value = Float(double / seconds)
        //self.currentTimeLabel.setTime(time: double)
        Player.instance.seek(time: CMTime(seconds: double, preferredTimescale: 1))
        dragSliderAllowed = true
        print("self.slider.value \(self.slider.value)")
    }
    
    private func setVideo() {
        //guard let videoURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/kinoogon-85687.appspot.com/o/17456232_1370733766319337_5195267787852873728_n.mp4?alt=media&token=7d22abb8-ed97-4438-a74a-4dddb79d12fc") else { return }
        let url = "https://firebasestorage.googleapis.com/v0/b/kinoogon-85687.appspot.com/o/17456232_1370733766319337_5195267787852873728_n.mp4?alt=media&token=7d22abb8-ed97-4438-a74a-4dddb79d12fc"
        Player.instance.url = url
    }
    
    @IBAction func closeButtonWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func playPauseButtonWasPressed(_ sender: Any) {
        if Player.instance.rate == 0 {
            Player.instance.play()
        } else {
            Player.instance.pause()
        }
    }

}

extension VideoVC: PlayerDelegate {
    func pause() {
        
    }
    
    func play() {
        
    }
    
    func setDuration(time: CMTime) {
        print("setDuration VideoVC \(CMTimeGetSeconds(time))")
    }
    
    func setTime(time: CMTime) {
        //print("setTime VideoVC")
    }
    
    func setPlayerLayer(playerLayer: AVPlayerLayer) {
        print("setPlayerLayer VideoVC")
        playerLayer.frame = view.bounds
        print("setPlayerLayer \(playerLayer.frame)")
        view.layer.addSublayer(playerLayer)
    }
    
//    override func setPlayerLayer(playerLayer: AVPlayerLayer) {
//
//    }
    
    
}
