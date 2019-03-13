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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global().async {
            let image = self.videoSnapshot(filePathLocal: "https://firebasestorage.googleapis.com/v0/b/kinoogon-85687.appspot.com/o/17456232_1370733766319337_5195267787852873728_n.mp4?alt=media&token=7d22abb8-ed97-4438-a74a-4dddb79d12fc")
            DispatchQueue.main.async {
                self.mainImage.image = image
            }
        }
        
    }
    
    private func addWebView() {
        let webConfiguration = WKWebViewConfiguration()
        //webConfiguration.
        webConfiguration.allowsInlineMediaPlayback = true
        if #available(iOS 10.0, *) {
            webConfiguration.mediaTypesRequiringUserActionForPlayback = []
        }
        let web = WKWebView(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.width / 16 * 9), configuration: webConfiguration)
        view.addSubview(web)
        //let url = URL(string: "https://youtube.com/embed/RmHqOSrkZnk?playsinline=1&rel=0&hd=1&showinfo=0&enablejsapi=1")!
        let url = URL(string: "https://youtube.com/embed/RmHqOSrkZnk?autoplay=1&playsinline=1&modestbranding=1")!
        web.load(URLRequest(url: url))
        //web.loadHTMLString("<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/d-bw5eV8BdY\" frameborder=\"0\" allow=\"accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture\" allowfullscreen></iframe>", baseURL: nil)
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
        
        guard let videoVC = storyboard?.instantiateViewController(withIdentifier: "VideoVC") as? VideoVC else { return }
        present(videoVC, animated: true, completion: nil)
    }
    
    

}
