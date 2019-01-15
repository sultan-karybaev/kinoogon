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
}

class Player: NSObject {
    
    public var url: String = "" {
        willSet {
            player = AVPlayer(url: URL(string: newValue)!)
            setPlayer()
            player.play()
        }
    }
    
    public var rate: Float {
        return player.rate
    }
    
    private var player = AVPlayer()
    private var observerContext = 0
    public var delegate: PlayerDelegate?
    
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
        player.pause()
        delegate?.pause()
    }
    
    public func play() {
        player.play()
        delegate?.play()
    }
    
    public func seek(time: CMTime) {
        player.seek(to: time)
        play()
    }
    
    public func add(observer: @escaping (CMTime) -> Void) {
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
            print("player.status \(player.status == AVPlayer.Status.readyToPlay)")
            if player.status == AVPlayer.Status.readyToPlay {
                if player.rate == 0 {
                    //self.play()
                }
            }
        }
    }
    
}
