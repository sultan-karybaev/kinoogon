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
        print("self.slider.value \(self.slider.value) \(double)")
        //self.currentTimeLabel.setTime(time: double)
        Player.instance.seek(time: CMTime(seconds: double, preferredTimescale: 1))
        dragSliderAllowed = true
        print("self.slider.value 222 \(self.slider.value)")
    }
    
    private func setVideo() {
        //guard let videoURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/kinoogon-85687.appspot.com/o/17456232_1370733766319337_5195267787852873728_n.mp4?alt=media&token=7d22abb8-ed97-4438-a74a-4dddb79d12fc") else { return }
        let url = "https://firebasestorage.googleapis.com/v0/b/kinoogon-85687.appspot.com/o/17456232_1370733766319337_5195267787852873728_n.mp4?alt=media&token=7d22abb8-ed97-4438-a74a-4dddb79d12fc"
        Player.instance.url = url
    }
    
    @IBAction func inside(_ sender: Any) {
        print("inside")
        Player.instance.pause()
        //guard let seconds = audioDuration?.seconds else { return }
        let seconds = Double(durationTest)
        let double = seconds * Double(slider.value)
        Player.instance.seek(time: CMTime(seconds: double, preferredTimescale: 1))
        dragSliderAllowed = true
        print("inside 2")
        //tapGestureRecognizer.isEnabled = true
    }
    
    @IBAction func outside(_ sender: Any) {
        print("outside")
        dragSliderAllowed = false
    }
    
    @IBAction func valueChanged(_ sender: Any) {
        print("valueChanged")
        dragSliderAllowed = false
    }
    
    @IBAction func touchDown(_ sender: Any) {
        print("touchDown")
        dragSliderAllowed = true
    }
    
    @IBAction func touchCancel(_ sender: Any) {
        print("touchCancel")
        if !self.isSliderTapped {
            Player.instance.pause()
            //guard let seconds = audioDuration?.seconds else { return }
            let seconds = Double(durationTest)
            let double = seconds * Double(slider.value)
            Player.instance.seek(time: CMTime(seconds: double, preferredTimescale: 1))
            dragSliderAllowed = true
            //self.isSliderTapped = false
            print("touchCancel 2 \(slider.value)")
        }
        
    }
    
    @IBAction func dradInside(_ sender: Any) {
        print("dradInside")
        self.isSliderTapped = false
        //dragSliderAllowed = true
    }
    
    @IBAction func closeButtonWasPressed(_ sender: Any) {
        print("closeButtonWasPressed VideoVC \(self.navigationController)")
        Player.instance.pause()
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
        //print("setPlayerLayer \(playerLayer.videoRect)")
        let seconds = time.seconds
        if self.dragSliderAllowed {
            self.slider.value = Float(seconds / Double(self.durationTest))
            print("setTime VideoVC \(self.slider.value) \(seconds)")
        }
        //self.currentTimeLabel.setTime(time: seconds)
    }
    
    func setPlayerLayer(playerLayer: AVPlayerLayer) {
        print("setPlayerLayer VideoVC \(playerLayer.isReadyForDisplay)")
        playerLayer.frame = CGRect(x: 0, y: 0, width: 717, height: 896)
        //playerLayer.frame = view.bounds
        //let f = playerLayer.videoGravity
        //AVLayerVideoGravity.resize.rawValue
        //playerLayer.frame.origin.y = 0
        //playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        //view.layer.addSublayer(playerLayer)
        view.layer.insertSublayer(playerLayer, at: 0)
        print("setPlayerLayer \(playerLayer.frame) \(playerLayer.videoRect)")
        print("AVLayerVideoGravity \(playerLayer.videoGravity.rawValue) \(AVLayerVideoGravity.resize.rawValue)")
    }
    
    
}
