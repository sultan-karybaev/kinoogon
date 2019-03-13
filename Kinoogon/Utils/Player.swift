//
//  Player.swift
//  Kinoogon
//
//  Created by Sultan Karybaev on 1/12/19.
//  Copyright © 2019 Sultan Karybaev. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer

protocol PlayerDelegate {
    func pause()
    func play()
    func setDuration(time: CMTime)
    func setTime(time: CMTime)
    func setPlayerLayer(playerLayer: AVPlayerLayer)
}

extension PlayerDelegate {
    func setPlayerLayer(playerLayer: AVPlayerLayer) {
        print("extension PlayerDelegate")
    }
}

class Player: NSObject {
    
    public var url: String = "" {
        willSet {
            if let timeObserver = self.timeObserver {
                self.player.removeTimeObserver(timeObserver)
                self.timeObserver = nil
            }
            self.player.replaceCurrentItem(with: nil)
            guard let url = URL(string: newValue) else { return }
            print("Player newValue")
            self.time = nil
            let asset = AVAsset(url: url)
            self.setPlayer()
            
            //self.player.removeTimeObserver(<#T##observer: Any##Any#>)
            
            asset.loadValuesAsynchronously(forKeys: ["duration", "playable"]) {
                print("Player loadValuesAsynchronously")
                let newItem = AVPlayerItem(asset: asset)
                print("asset.duration \(asset.duration)")
                let interval = CMTimeMake(value: 1, timescale: 4)
                self.player.replaceCurrentItem(with: newItem)
                self.playerLayer = AVPlayerLayer(player: self.player)
                DispatchQueue.main.async {
                    self.delegate?.setPlayerLayer(playerLayer: self.playerLayer)
                }
                
                print("self.delegate \(self.delegate) \(self.playerLayer)")
                if let time = self.time { self.player.seek(to: time) }
                self.timeObserver = self.player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (time) in
                    print("Player delegate")
                    self.delegate?.setTime(time: time)
                })
                //self.player.playImmediately(atRate: <#T##Float#>)
                //self.player.timeControlStatus
                
                DispatchQueue.main.async {
                    self.delegate?.setDuration(time: asset.duration)
                    self.play()
                }
                
                print("Player url")
            }
//            AVAsset *asset = [AVAsset assetWithURL:self.mediaURL];
//            [asset loadValuesAsynchronouslyForKeys:@[@"duration"] completionHandler:^{
//                AVPlayerItem *newItem = [[AVPlayerItem alloc] initWithAsset:asset];
//                [self.avPlayer replaceCurrentItemWithPlayerItem:newItem];
//                }];
        }
    }
    
    public var rate: Float {
        return player.rate
    }
        
    private let player = AVPlayer()
    private var playerLayer = AVPlayerLayer()
//    public var playerLayer: AVPlayerLayer {
//        return AVPlayerLayer(player: self.player)
//    }
    private var observerContext = 0
    public var delegate: PlayerDelegate?
    private var time: CMTime?
    private var timeObserver: Any?
    
    static public let instance = Player()
    
    private override init() {
        super.init()
//        self.add { (time) in
//            print("Player delegate")
//            self.delegate?.setTime(time: time)
//        }
        MPRemoteCommandCenter.shared().pauseCommand.addTarget(self, action: #selector(onPauseRemoteCommand))
        MPRemoteCommandCenter.shared().playCommand.addTarget(self, action: #selector(onPlayRemoteCommand))
    }
    
    @objc func onPauseRemoteCommand() {
        print("onPauseRemoteCommand")
    }
    
    @objc func onPlayRemoteCommand() {
        print("onPlayRemoteCommand")
    }
    
    private func setPlayer() {
        if #available(iOS 10.0, *) {
            player.automaticallyWaitsToMinimizeStalling = false
        }
        player.addObserver(self, forKeyPath: "reasonForWaitingToPlay", options: .new, context: &observerContext)
        do {
            if #available(iOS 10.0, *) {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            } else {
                //try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, with: .mixWithOthers)
            }
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
        } catch {
            print(error)
        }
    }
    
    public func pause() {
        print("Player pause")
        player.pause()
        delegate?.pause()
    }
    
    public func play() {
        print("Player play")
        player.play()
        delegate?.play()
    }
    
    public func seek(time: CMTime) {
        print("Player seek")
        self.time = time
        player.seek(to: time) { (_) in
            //self.play()
        }
        play()
    }
    
    public func seetToZero() {
        player.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
        //play()
    }
    
    public func add(observer: @escaping (CMTime) -> Void) {
        print("Player add")
        let interval = CMTimeMake(value: 1, timescale: 4)
        if let timeObserver = timeObserver {player.removeTimeObserver(timeObserver)}
        //player.add
        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: observer)
    }
    
    public func stop() {
        //player = AVPlayer()
        player.pause()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard context == &observerContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        print("observeValue")
        // look at `change![.newKey]` to see what the status is, e.g.
        
        if keyPath == "reasonForWaitingToPlay" {
            //NSLog("\(keyPath): \(change![.newKey])")
            print("player.status \(player.status == AVPlayer.Status.readyToPlay)")
            if player.status == AVPlayer.Status.readyToPlay {
                if player.rate == 0 {
                    //self.play()
                }
            }
        }
    }
    
}
