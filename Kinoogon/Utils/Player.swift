//
//  Player.swift
//  Kinoogon
//
//  Created by Sultan Karybaev on 1/12/19.
//  Copyright © 2019 Sultan Karybaev. All rights reserved.
//

import Foundation
import AVFoundation

protocol PlayerDelegate {
    func pause()
    func play()
    func setDuration(time: CMTime)
}

class Player: NSObject {
    
    public var url: String = "" {
        willSet {
            guard let url = URL(string: newValue) else { return }
//            DispatchQueue.global().async {
//                self.player = AVPlayer(url: url)
//                self.setPlayer()
//                self.player.play()
//                print("Player url")
//            }
            print("Player newValue")
            self.time = nil
            let asset = AVAsset(url: url)
            self.setPlayer()
            asset.loadValuesAsynchronously(forKeys: ["duration", "playable"]) {
                print("Player loadValuesAsynchronously")
                let newItem = AVPlayerItem(asset: asset)
                print("asset.duration \(asset.duration)")
                
                //asset.duration
                self.player.replaceCurrentItem(with: newItem)
                //self.player.playImmediately(atRate: <#T##Float#>)
                if let time = self.time {
                    self.player.seek(to: time)
                }
                
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
    
    private var player = AVPlayer()
    private var observerContext = 0
    public var delegate: PlayerDelegate?
    private var time: CMTime?
    
    static public let instance = Player()
    
    private override init() {
        super.init()
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
        player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: observer)
    }
    
    public func stop() {
        player = AVPlayer()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard context == &observerContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        // look at `change![.newKey]` to see what the status is, e.g.
        
        if keyPath == "reasonForWaitingToPlay" {
            //NSLog("\(keyPath): \(change![.newKey])")
            //print("player.status \(player.status == AVPlayer.Status.readyToPlay)")
            if player.status == AVPlayer.Status.readyToPlay {
                if player.rate == 0 {
                    //self.play()
                }
            }
        }
    }
    
}
