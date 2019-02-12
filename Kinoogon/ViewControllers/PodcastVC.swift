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
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var imageSize: NSLayoutConstraint!
    @IBOutlet weak var mainImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainImageCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var sliderViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var sliderViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var sliderViewCenterYConstraint: NSLayoutConstraint!
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
    private var durationTest = 1882
    
    private var dragSliderAllowed: Bool = true
    private var isSliderTapped: Bool = false
    public var delegate: PodcastDelegate?
    public var audioSource: String = "" {
        willSet {
//            DispatchQueue.global().async {
//                Player.instance.stop()
//            }
            self.refresh()
            setPlayer(source: newValue)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Player.instance.delegate = self
        self.setNavigationBackButton()
        self.setLayer()
        setPlayPauseImage(imageName: "rounded-pause-button", littleImageName: "music-player-pause-lines")
        slider.setCircle()
        let fire = "https://firebasestorage.googleapis.com/v0/b/kinoogon-85687.appspot.com/o/podcasts%2F2019-01-04%2011.19.06.mp3?alt=media&token=4ffff425-38b0-48ef-9cce-939d45fe693e"
        //setPlayer(source: fire)
        currentTimeLabel.setTime(time: 0)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sliderTapped(gestureRecognizer:)))
        self.slider.addGestureRecognizer(tapGestureRecognizer)
        
        //let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(sliderViewTapped(gestureRecognizer:)))
        let pan = UIPanGestureRecognizer(target: self, action: nil)
        //self.sliderView.addGestureRecognizer(tapGestureRecognizer2)
        self.sliderView.addGestureRecognizer(pan)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
//        Player.instance.add(observer: { time in
//            //print("!self.slider.isTouchInside \(time)")
//            if self.dragSliderAllowed {
//                self.slider.value = Float(time.seconds / self.asset.duration.seconds)
//            }
//            //print("time.seconds \(time.seconds)")
//            self.currentTimeLabel.setTime(time: time.seconds)
//        })
        
        
        //test
        self.durationTimeLabel.setTime(time: Double(self.durationTest))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("PodcastVC viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("PodcastVC viewDidAppear")
    }
    
    private func setPlayer(source: String) {
        print("setPlayer \(source)")
        self.playerPlay(url: source)
//        Storage.storage().reference().child("[BadComedian] - Ёлки 666 (НОВЫЙ ГОД В АДУ).mp4").downloadURL { (url, error) in
//            if let error = error {
//                debugPrint("PodcastVC.swift \(error.localizedDescription)")
//            } else {
//
//            }
//        }
    }
    
    public func refresh() {
        print("refresh start")
        guard let slider = self.slider else { return }
        guard let currentTimeLabel = self.currentTimeLabel else { return }
        slider.value = 0
        currentTimeLabel.setTime(time: 0)
        setPlayPauseImage(imageName: "rounded-pause-button", littleImageName: "music-player-pause-lines")
        print("refresh finish")
    }
    
    private func setLayer() {
        let closeIcon = UIImage(named: "cancel-music")?.withRenderingMode(.alwaysTemplate)
        closeButtonRolled.setImage(closeIcon, for: .normal)
        closeButtonRolled.imageView?.contentMode = .scaleAspectFit
        closeButtonRolled.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        podcastNameLabel.text = self.podcastName
        imageSize.constant = view.frame.height * 0.3
        mainImageHeightConstraint.constant = view.frame.height * 0.3
    }
    
    @objc func playerDidFinishPlaying() {
        Player.instance.seek(time: CMTime(seconds: 0, preferredTimescale: 1))
        Player.instance.pause()
        setPlayPauseImage(imageName: "play-button-3", littleImageName: "music-player-play")
    }
    
    @objc func sliderViewTapped(gestureRecognizer: UIGestureRecognizer) {
        print("sliderViewTapped")
        //Player.instance.pause()
        let pointTapped: CGPoint = gestureRecognizer.location(in: self.sliderView)
        print("pointTapped \(pointTapped)")
    }
    
    @objc func sliderTapped(gestureRecognizer: UITapGestureRecognizer) {
        print("sliderTapped ---------------------------------------------")
        self.isSliderTapped = true
        Player.instance.pause()
        print("gestureRecognizer.location(in: nil) \(gestureRecognizer.location(in: nil))")
        print("gestureRecognizer.location(ofTouch: 0, in: nil) \(gestureRecognizer.location(ofTouch: 0, in: nil))")
        //print("gestureRecognizer.location(ofTouch: 1, in: nil) \(gestureRecognizer.location(ofTouch: 1, in: nil))")
        let pointTapped: CGPoint = gestureRecognizer.location(ofTouch: 0, in: self.sliderView)
        let positionOfSlider: CGPoint = slider.frame.origin
        let widthOfSlider: CGFloat = slider.frame.size.width
        let newValue = (pointTapped.x - positionOfSlider.x) * CGFloat(slider.maximumValue) / widthOfSlider
        //guard let seconds = audioDuration?.seconds else { return }
        let seconds = Double(durationTest)
        let double = seconds * Double(newValue)
        self.slider.value = Float(double / seconds)
        self.currentTimeLabel.setTime(time: double)
        Player.instance.seek(time: CMTime(seconds: double, preferredTimescale: 1))
        dragSliderAllowed = true
        print("self.slider.value \(self.slider.value)")
        
        
        
//        let d = DispatchWorkItem {
//            Player.instance.pause()
//            let pointTapped: CGPoint = gestureRecognizer.location(in: self.sliderView)
//            let positionOfSlider: CGPoint = self.slider.frame.origin
//            let widthOfSlider: CGFloat = self.slider.frame.size.width
//            let newValue = (pointTapped.x - positionOfSlider.x) * CGFloat(self.slider.maximumValue) / widthOfSlider
//            //guard let seconds = audioDuration?.seconds else { return }
//            let seconds = Double(self.durationTest)
//            let double = seconds * Double(newValue)
//            Player.instance.seek(time: CMTime(seconds: double, preferredTimescale: 1))
//
//            DispatchQueue.main.async {
//                self.slider.value = Float(double / seconds)
//                self.currentTimeLabel.setTime(time: double)
//                self.dragSliderAllowed = true
//            }
//        }
//        DispatchQueue.global(qos: .background).async(execute: d)
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
    
    @IBAction func touchDownRepeat(_ sender: Any) {
        print("touchDownRepeat")
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
    
    @IBAction func primaryActionTriggerred(_ sender: Any) {
        print("primaryActionTriggerred")
    }
    
    @IBAction func didEndOnExit(_ sender: Any) {
        print("didEndOnExit")
    }
    
    @IBAction func editingChanged(_ sender: Any) {
        print("editingChanged")
    }
    
    @IBAction func editingDidBegin(_ sender: Any) {
        print("editingDidBegin")
    }
    
    @IBAction func editingDidEnd(_ sender: Any) {
        print("editingDidEnd")
    }
    
    
    @IBAction func dragEnter(_ sender: Any) {
        print("dragEnter")
    }
    
    @IBAction func dragExit(_ sender: Any) {
        print("dragExit")
    }
    
    @IBAction func dradInside(_ sender: Any) {
        print("dradInside")
        self.isSliderTapped = false
        //dragSliderAllowed = true
    }
    
    @IBAction func dragOutside(_ sender: Any) {
        print("dragOutside")
    }
    
    @IBAction func togglePlayPause(_ sender: Any) {
        if Player.instance.rate == 0 {
            Player.instance.play()
        } else {
            Player.instance.pause()
        }
    }
    
    @IBAction func closeButtonWasPressed(_ sender: Any) {
        closeTest()
    }
    
    public func closeTest() {
        delegate?.closePodcast()
        DispatchQueue.global().async {
            Player.instance.stop()
        }
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
        print("backButtonTapped")
        delegate?.rollPodcast()
    }
    
    private func playerPlay(url: String) {
        print("playerPlay")
        
        
        //Player.instance.seek(time: CMTime(seconds: 0, preferredTimescale: 1))
        //if self.currentTimeLabel != nil { self.currentTimeLabel.setTime(time: 0) }
//        DispatchQueue.global().async {
//            self.asset = AVURLAsset(url: URL(string: url)!, options: nil)
//            self.audioDuration = self.asset.duration
//            self.audioDurationSeconds = CMTimeGetSeconds(self.asset.duration)
//            Player.instance.add(observer: { time in
//                //print("!self.slider.isTouchInside \(time)")
//                if self.dragSliderAllowed {
//                    self.slider.value = Float(time.seconds / self.asset.duration.seconds)
//                }
//                self.currentTimeLabel.setTime(time: time.seconds)
//            })
//            DispatchQueue.main.async {
//                print("Double(self.audioDurationSeconds) \(Double(self.audioDurationSeconds))")
//                self.durationTimeLabel.setTime(time: Double(self.audioDurationSeconds))
//            }
//        }
        //DispatchQueue.global().
        
        let d = DispatchWorkItem {
            Player.instance.url = url
            DispatchQueue.main.async {
                Player.instance.add(observer: { time in
                    let seconds = time.seconds
                    if self.dragSliderAllowed {
                        //print("dragSliderAllowed")
                        //self.slider.value = Float(seconds / self.asset.duration.seconds)
                        self.slider.value = Float(seconds / Double(self.durationTest))
                        
                    }
                    //print("time.seconds \(time.seconds)")
                    self.currentTimeLabel.setTime(time: seconds)
                })
            }
            print("DispatchWorkItem")
            DispatchQueue.main.async {
               if self.currentTimeLabel != nil && self.slider != nil {
                    self.slider.value = 0
                    self.currentTimeLabel.setTime(time: 0)
                    print("self.currentTimeLabel.setTime(time: 0)")
                }
            }
            
            //Player.instance.seek(time: CMTime(seconds: 0, preferredTimescale: 1))
            
//            self.asset = AVURLAsset(url: URL(string: url)!, options: nil)
//            self.asset.loadValuesAsynchronously(forKeys: ["duration"], completionHandler: {
//                print("AVURLAsset loadValuesAsynchronously")
//                self.audioDuration = self.asset.duration
//                self.audioDurationSeconds = CMTimeGetSeconds(self.asset.duration)
//                self.durationTimeLabel.setTime(time: Double(self.audioDurationSeconds))
//            })
            
            
//            DispatchQueue.main.async {
//                print("Double(self.audioDurationSeconds) \(Double(self.audioDurationSeconds))")
//                self.durationTimeLabel.setTime(time: Double(self.audioDurationSeconds))
//                
//            }
            
        }
        DispatchQueue.global(qos: .background).async(execute: d)
        print("DispatchQueue.global(qos: .background).async(execute: d)")
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


