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
    func closePodcast()
}

class PodcastVC: UIViewController {

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var imageSize: NSLayoutConstraint!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationTimeLabel: UILabel!
    
    var player: AVPlayer!
    var music = Bundle.main.path(forResource: "Blue - Curtain Falls", ofType: "mp3")!
    let video = Bundle.main.path(forResource: "video", ofType: "mp4")!
    var asset: AVURLAsset!
    var audioDuration: CMTime!
    var audioDurationSeconds: Float64!
    var tapGestureRecognizer: UITapGestureRecognizer!
    let youtube = "https://www.youtube.com/watch?v=YrlS5BUrhdY"
    
    var audioPlayer: AVAudioPlayer!
    
    public var delegate: PodcastDelegate?
    
    override func viewDidLoad() {
        print("viewDidLoad PodcastVC")
        super.viewDidLoad()
        self.setNavigationBackButton()
        currentTimeLabel.setTime(time: 0)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sliderTapped(gestureRecognizer:)))
        self.slider.addGestureRecognizer(tapGestureRecognizer)
        
        //imageSize.constant = view.frame.height * 0.3
        
        setPlayPauseImage(imageName: "rounded-pause-button")
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        slider.setCircle()
        
        let fire = "https://firebasestorage.googleapis.com/v0/b/kinoogon-85687.appspot.com/o/podcasts%2F2019-01-04%2011.19.06.mp3?alt=media&token=4ffff425-38b0-48ef-9cce-939d45fe693e"
        //self.playerPlay(url: fire)
        Player.instance.delegate = self
        
        Storage.storage().reference().child("[BadComedian] - Ёлки 666 (НОВЫЙ ГОД В АДУ).mp4").downloadURL { (url, error) in
            if let error = error {
                debugPrint("PodcastVC.swift \(error.localizedDescription)")
            } else {
                //print("111111111111111111111 \(url)")
                //self.playerPlay(url: url!)
                
                //self.playerPlay(url: NSURL(string: vk) as! URL)
            }
        }
        
        
//        Storage.storage().reference().child("[BadComedian] - Ёлки 666 (НОВЫЙ ГОД В АДУ).mp4").getData(maxSize: 1000000000) { (data, error) in
//            print("222222222222222 \(data)")
//            if let error = error {
//                debugPrint("\(error.localizedDescription)")
//            }
//            if let data = data {
//                let bcf = ByteCountFormatter()
//                bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
//                bcf.countStyle = .file
//                let string = bcf.string(fromByteCount: Int64(data.count))
//                print("formatted result: \(string)")
//            }
//        }
        
        
    }
    
    @objc func playerDidFinishPlaying() {
        print("Video Finished")
        Player.instance.seek(time: CMTime(seconds: 0, preferredTimescale: 1))
        Player.instance.pause()
        setPlayPauseImage(imageName: "play-button-3")
    }
    
    @objc func sliderTapped(gestureRecognizer: UIGestureRecognizer) {
        print("sliderTapped")
        Player.instance.pause()
        let pointTapped: CGPoint = gestureRecognizer.location(in: self.view)
        let positionOfSlider: CGPoint = slider.frame.origin
        let widthOfSlider: CGFloat = slider.frame.size.width
        let newValue = (pointTapped.x - positionOfSlider.x) * CGFloat(slider.maximumValue) / widthOfSlider
        let double = audioDuration.seconds * Double(newValue)
        Player.instance.seek(time: CMTime(seconds: double, preferredTimescale: 1))
    }
    
    @IBAction func inside(_ sender: Any) {
        print("inside")
        Player.instance.pause()
        let double = audioDuration.seconds * Double(slider.value)
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
        //self.dismiss(animated: true, completion: nil)
        delegate?.closePodcast()
    }
    
    private func playerPlay(url: String) {
        Player.instance.url = url
        DispatchQueue.global().async {
            self.asset = AVURLAsset(url: URL(string: url)!, options: nil)
            self.audioDuration = self.asset.duration
            self.audioDurationSeconds = CMTimeGetSeconds(self.audioDuration)
            Player.instance.add(observer: { time in
                if !self.slider.isTouchInside {
                    self.slider.value = Float(time.seconds / self.audioDuration.seconds)
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
        setPlayPauseImage(imageName: "play-button-3")
    }
    
    func play() {
        setPlayPauseImage(imageName: "rounded-pause-button")
    }
    
    
}


