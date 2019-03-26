//
//  TopListVC.swift
//  Kinoogon
//
//  Created by Sultan Karybaev on 12/2/18.
//  Copyright © 2018 Sultan Karybaev. All rights reserved.
//

import UIKit
import WebKit
import AVFoundation

class TopListVC: UIViewController {

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let pinterestLayout = PinterestLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global().async {
            let image = self.videoSnapshot(filePathLocal: "https://firebasestorage.googleapis.com/v0/b/kinoogon-85687.appspot.com/o/17456232_1370733766319337_5195267787852873728_n.mp4?alt=media&token=7d22abb8-ed97-4438-a74a-4dddb79d12fc")
            DispatchQueue.main.async {
                self.mainImage.image = image
            }
        }
        collectionView.collectionViewLayout = pinterestLayout
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    
    func videoSnapshot(filePathLocal: NSString) -> UIImage? {
        
        //let vidURL = NSURL(fileURLWithPath:filePathLocal as String)
        guard let vidURL = NSURL(string: filePathLocal as String) else { return nil }
        print("vidURL \(vidURL)")
        let asset = AVURLAsset(url: vidURL as URL)
        print("asset \(asset)")
        let generator = AVAssetImageGenerator(asset: asset)
        print("generator \(generator)")
        generator.appliesPreferredTrackTransform = true
        
        let timestamp = CMTime(seconds: 1, preferredTimescale: 60)
        
        do {
            let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
            return UIImage(cgImage: imageRef)
        }
        catch let error as NSError
        {
            print("Image generation failed with error \(error)")
            return nil
        }
    }
    
    @IBAction func buttonWasPressed(_ sender: Any) {
//        let videoURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/kinoogon-85687.appspot.com/o/17456232_1370733766319337_5195267787852873728_n.mp4?alt=media&token=7d22abb8-ed97-4438-a74a-4dddb79d12fc")
//        let player = AVPlayer(url: videoURL!)
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = playerView.bounds
//        playerView.layer.addSublayer(playerLayer)
//        player.play()
        
//        mainNC.podcastView.removeFromSuperview()
//        Player.instance.pause()
        
        guard let tabBC = self.tabBarController else { return }
        self.navigationController?.viewControllers = [tabBC]
        print("buttonWasPressed TopListVC \(self.navigationController?.view.subviews) \(self.navigationController?.children)")
        guard let videoVC = storyboard?.instantiateViewController(withIdentifier: "VideoVC") as? VideoVC else { return }
        present(videoVC, animated: true, completion: nil)
    }
    
}

extension TopListVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? Cell else { return UICollectionViewCell() }
        cell.contentView.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        cell.contentView.layer.cornerRadius = 10
        return cell
    }
    
    
}
