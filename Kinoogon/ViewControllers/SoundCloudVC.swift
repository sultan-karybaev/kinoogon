//
//  SoundCloudVC.swift
//  Kinoogon
//
//  Created by Sultan Karybaev on 11/22/18.
//  Copyright © 2018 Sultan Karybaev. All rights reserved.
//

import UIKit
import AVFoundation

class SoundCloudVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomSafeAreaConstraint: NSLayoutConstraint!
    
    private var mainNC: UINavigationController!
    private var podcastNC: PodcastNC!
    private var podcastVC: PodcastVC!
    
    private var podcastView: UIView! = UIView()
    
    let radio = "http://strm112.1.fm/acountry_mobile_mp3"
    
    private var leftBarButtonItem : UIBarButtonItem!
    
    private var navigationLeftButton : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.navigationItem.title = "Подкасты"
//        tabBarController?.navigatio
//        UITabBarController.app
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.separatorColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 1)
        tableView.bounces = false
        tableView.backgroundView = nil
        tableView.backgroundColor = #colorLiteral(red: 0.0862745098, green: 0.1294117647, blue: 0.1803921569, alpha: 1)
        tableView.layer.backgroundColor = #colorLiteral(red: 0.0862745098, green: 0.1294117647, blue: 0.1803921569, alpha: 1)
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        addPodcastView()
    }
    
    private func addPodcastView() {
        mainNC = self.navigationController!
        podcastNC = storyboard!.instantiateViewController(withIdentifier: "PodcastNC") as! PodcastNC
        podcastVC = podcastNC.viewControllers[0] as! PodcastVC
        podcastVC.delegate = self
        podcastView = UIView(frame: CGRect(x: mainNC.view.frame.width, y: mainNC.navigationBar.frame.origin.y, width: mainNC.view.frame.width, height: mainNC.view.frame.height - mainNC.navigationBar.frame.origin.y))
        podcastView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        mainNC.addChild(podcastNC)
        podcastView.addSubview(podcastNC.view)
        mainNC.view.addSubview(podcastView)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        podcastNC.view.addGestureRecognizer(pan)
    }
    
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        //gestureRecognizer.state = .ended
        let translation = gestureRecognizer.translation(in: view)
        //let horizontalMovement = translation.x / view.bounds.width
        let horizontalMovement = translation.y / view.bounds.height
        let downwardMovement = fmaxf(Float(horizontalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)
        print("progress \(translation)")
        switch gestureRecognizer.state {
            case .began, .changed:
                
                if translation.y >= 0 {
                    podcastView.frame.origin.y = translation.y
                }
                if progress <= 0.5 {
                    podcastVC.imageSize.constant = 160 + ((self.view.frame.width - 160) * progress * 2)
                } else {
                    podcastVC.imageSize.constant = 160 + ((self.view.frame.width - 160) * (1 - progress) * 2)
                }
            case .cancelled, .ended:
                self.closeAnimation(duration: 1.2 * ( 1 - progress))
                break
            default:
                break
        }
        
    }
    
    private func closeAnimation(duration: CGFloat) {
        let displayLink = CADisplayLink(target: self, selector: #selector(animationDidUpdate))
        displayLink.frameInterval = 3
        displayLink.add(to: RunLoop.main, forMode: RunLoop.Mode.default)
        //dewfewf
        //UIView.animate(
        UIView.animate(withDuration: TimeInterval(exactly: Double(duration))!, delay: 0.0, options: .curveEaseInOut, animations: {
            self.podcastView.frame.origin.y = self.view.frame.height
        }, completion: { (_) in
            displayLink.invalidate()
            self.podcastView.removeFromSuperview()
            self.addPodcastView()
            print("we44")
            
            //NSKeyValueChange
        })
    }
    
    @objc func animationDidUpdate(displayLink: CADisplayLink) {
        print("animationDidUpdate \(self.podcastView.layer.presentation()?.frame)")
        //fewfwe
    }
    
}

extension SoundCloudVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SoundCloudCell") as? SoundCloudCell else {
            return SoundCloudCell()
        }
        if indexPath.row == 0 {
            cell.separatorView.isHidden = true
        } else {
            cell.separatorView.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt")
        //let vc = storyboard?.instantiateViewController(withIdentifier: "PodcastNC")
        tableView.deselectRow(at: indexPath, animated: true)
        //present(vc!, animated: true, completion: nil)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.podcastView.frame.origin.x = 0
        }, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 81
    }
}

extension SoundCloudVC: PodcastDelegate {
    func closePodcast() {
        self.closeAnimation(duration: 1.2)
    }
}
