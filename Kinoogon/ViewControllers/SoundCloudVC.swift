//
//  SoundCloudVC.swift
//  Kinoogon
//
//  Created by Sultan Karybaev on 11/22/18.
//  Copyright © 2018 Sultan Karybaev. All rights reserved.
//

import UIKit
//import AVFoundation

class SoundCloudVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomSafeAreaConstraint: NSLayoutConstraint!
    
    private var mainNC: MainNC!
    private var tabbar: UITabBarController!
    private var podcastNC: PodcastNC!
    private var podcastVC: PodcastVC!
    private var XConstraint: NSLayoutConstraint!
    private var YConstraint: NSLayoutConstraint!
    private var heightConstraint: NSLayoutConstraint!
    
    private var podcastView: UIView = UIView()
    private var startTime: TimeInterval!
    private var animationWasStarted: Bool = false
    private var animationIsReversed: Bool = false
    private var secondStageWasStarted: Bool = false
    private var startImageWidth: CGFloat!
    private var startImageHeight: CGFloat!
    private var startImageTop: CGFloat!
    private var tabbarOriginY: CGFloat!
    
    private var defaultAnimationDuration: CGFloat = 0.4
    private var setAnimationDuration: CGFloat?
    private var isRolledUp: Bool = false
    private var isRolledLayerSet: Bool = false
    private var verticalProgress: Bool = false
    private var progressVerticalHasBegun: Bool = false
    private var progressHorizontalHasBegun: Bool = false
    
    private var leftBarButtonItem : UIBarButtonItem!
    private var navigationLeftButton : UIButton!
    
    private var mainHeight: CGFloat = 0
    private var mainOriginY: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.backgroundView = nil
        tableView.backgroundColor = #colorLiteral(red: 0.0862745098, green: 0.1294117647, blue: 0.1803921569, alpha: 1)
        tableView.layer.backgroundColor = #colorLiteral(red: 0.0862745098, green: 0.1294117647, blue: 0.1803921569, alpha: 1)
        
        guard let mainNC = self.navigationController as? MainNC else { return }
        self.mainNC = mainNC
        mainHeight = mainNC.view.frame.height
        mainOriginY = mainNC.navigationBar.frame.origin.y
        tabbar = self.tabBarController!
        tabbarOriginY = self.tabbar.tabBar.frame.origin.y
        guard let podcastNC = storyboard?.instantiateViewController(withIdentifier: "PodcastNC") as? PodcastNC else { return }
        self.podcastNC = podcastNC
        podcastVC = podcastNC.viewControllers[0] as! PodcastVC
        podcastVC.delegate = self
        print("podcastNC \(self.podcastNC)")
        //podcastView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//        podcastView.clipsToBounds = true
//        podcastView.addSubview(podcastNC.view)
//        mainNC.view.addSubview(podcastView)
        
        //addPodcastView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigation()
    }
    
    private func setStartValues() {
        if mainNC.startImageWidth == nil { mainNC.startImageWidth = podcastVC.imageSize.constant }
        if mainNC.startImageTop == nil { mainNC.startImageTop = podcastVC.mainImageTopConstraint.constant }
        if mainNC.startImageHeight == nil { mainNC.startImageHeight = podcastVC.mainImageHeightConstraint.constant }
        startImageWidth = mainNC.startImageWidth!
        startImageTop = mainNC.startImageTop!
        startImageHeight = mainNC.startImageHeight!
        podcastVC.imageSize.constant = mainNC.startImageWidth!
        podcastVC.mainImageTopConstraint.constant = mainNC.startImageTop!
        podcastVC.mainImageHeightConstraint.constant = mainNC.startImageHeight!
        podcastVC.mainImageCenterXConstraint.constant = 0
    }
    
    private func setNavigation() {
        tabBarController?.navigationItem.title = "Подкасты"
        let textAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    private func addPodcastView() {
        podcastView = UIView(frame: CGRect(x: mainNC.view.frame.width, y: mainNC.navigationBar.frame.origin.y, width: mainNC.view.frame.width, height: mainNC.view.frame.height - mainNC.navigationBar.frame.origin.y))
        podcastView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        podcastView.clipsToBounds = true
        mainNC.addChild(podcastNC)
        podcastView.addSubview(podcastNC.view)
        podcastNC.view.translatesAutoresizingMaskIntoConstraints = false
        podcastNC.view.topAnchor.constraint(equalTo: podcastView.topAnchor, constant: 0).isActive = true
        podcastNC.view.leadingAnchor.constraint(equalTo: podcastView.leadingAnchor, constant: 0).isActive = true
        podcastNC.view.trailingAnchor.constraint(equalTo: podcastView.trailingAnchor, constant: 0).isActive = true
        podcastNC.view.bottomAnchor.constraint(equalTo: podcastView.bottomAnchor, constant: 0).isActive = true
        mainNC.view.addSubview(podcastView)
        podcastView.translatesAutoresizingMaskIntoConstraints = false
        YConstraint = podcastView.topAnchor.constraint(equalTo: mainNC.view.topAnchor, constant: mainNC.navigationBar.frame.origin.y)
        YConstraint.isActive = true
        XConstraint = podcastView.centerXAnchor.constraint(equalTo: mainNC.view.centerXAnchor, constant: mainNC.view.frame.width)
        XConstraint.isActive = true
        heightConstraint = podcastView.heightAnchor.constraint(equalToConstant: mainNC.view.frame.height - mainNC.navigationBar.frame.origin.y)
        heightConstraint.isActive = true
        podcastView.widthAnchor.constraint(equalToConstant: mainNC.view.frame.width).isActive = true
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        podcastNC.view.addGestureRecognizer(pan)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        podcastNC.view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap() {
        if isRolledUp {
            self.animationIsReversed = true
            let duration: CGFloat = calculateTime(currentValue: 200, startValue: 80, change: self.mainNC.view.frame.height - self.mainNC.navigationBar.frame.origin.y - 80, duration: defaultAnimationDuration)
            UIView.animate(withDuration: TimeInterval(exactly: Double(duration))!, delay: 0, options: .curveEaseInOut, animations: {
                self.podcastVC.mainImageCenterXConstraint.constant = 0
                self.podcastVC.mainImageHeightConstraint.constant = self.startImageHeight
                self.podcastVC.imageSize.constant = self.mainNC.view.frame.width
                self.podcastVC.sliderViewLeadingConstraint.constant = self.view.frame.width + 20
                self.podcastVC.closeButtonViewTrailingConstraint.constant = 80 + 20 - self.view.frame.width
                self.mainNC.view.layoutIfNeeded()
            }, completion: { (_) in
                self.setRolledLayer(false)
            })
            self.closeAnimation(duration: defaultAnimationDuration, duration2: defaultAnimationDuration / 2, close: false, delay: defaultAnimationDuration / 2)
        }
    }
    
    private func verticalProgressingMain(translation: CGPoint, progress: CGFloat) {
        if progress > 0 && progress < 1 {
            YConstraint.constant += translation.y
            heightConstraint.constant = 80 + (mainNC.view.frame.height - mainNC.navigationBar.frame.origin.y - 80) * (1 - progress)
            tabbar.tabBar.frame.origin.y = YConstraint.constant + heightConstraint.constant
        } else if progress == 0 {
            YConstraint.constant = mainNC.navigationBar.frame.origin.y
            heightConstraint.constant = mainNC.view.frame.height - mainNC.navigationBar.frame.origin.y
            tabbar.tabBar.frame.origin.y = YConstraint.constant + heightConstraint.constant
            return
        } else if progress == 1 {
            YConstraint.constant = tabbarOriginY - 80
            heightConstraint.constant = 80
            tabbar.tabBar.frame.origin.y = tabbarOriginY
            return
        }
        let secondFullProgress: CGFloat = 1 - (200 - 80) / (mainNC.view.frame.height - mainNC.navigationBar.frame.origin.y - 80)
        let f = (1 - progress) / (1 - secondFullProgress)
        if progress >= 0 && progress <= 0.5 {
            //podcastNC.navigationBar.alpha = (1 - progress * 2)
            podcastVC.imageSize.constant = startImageWidth + ((self.view.frame.width - startImageWidth) * progress * 2)
            podcastVC.mainImageTopConstraint.constant = startImageTop * (1 - progress * 2)
            podcastVC.mainImageCenterXConstraint.constant = 0
            podcastVC.mainImageHeightConstraint.constant = startImageHeight
            self.mainNC.view.layoutIfNeeded()
            podcastNC.navigationBar.alpha = (1 - progress * 2)
        } else if progress > 0.5 {
            podcastNC.navigationBar.alpha = 0
            //podcastVC.imageSize.constant = self.view.frame.width
            podcastVC.mainImageTopConstraint.constant = 0
            //podcastVC.mainImageCenterXConstraint.constant = 0
            //podcastVC.mainImageHeightConstraint.constant = startImageHeight
            if isRolledLayerSet { self.setRolledLayer(false) }
            if heightConstraint.constant <= 200 {
                if !isRolledLayerSet { self.setRolledLayer(true) }
                podcastVC.mainImageCenterXConstraint.constant = (40 - self.mainNC.view.frame.width / 2) * (1 - (1 - progress) / (1 - secondFullProgress))
                podcastVC.mainImageHeightConstraint.constant = 80 + (startImageHeight - 80) * f
                podcastVC.imageSize.constant = 80 + (self.view.frame.width - 80) * f
                self.podcastVC.sliderViewLeadingConstraint.constant = 80 + 20 + (self.view.frame.width - 80) * f
                self.podcastVC.closeButtonViewTrailingConstraint.constant = 0 + (80 + 20 - self.view.frame.width) * f
            } else {
                podcastVC.imageSize.constant = self.view.frame.width
                podcastVC.mainImageCenterXConstraint.constant = 0
                podcastVC.mainImageHeightConstraint.constant = startImageHeight
            }
        }
        
    }
    
    private func horizontalProgress(translation: CGPoint, progress: CGFloat) {
        podcastNC.navigationBar.alpha = 1 - progress
        //print("podcastNC.navigationBar.alpha \(podcastNC.navigationBar.alpha)")
        if progress > 0 && progress < 1 {
            XConstraint.constant += translation.x
        } else if progress == 0 {
            XConstraint.constant = 0
            return
        } else if progress == 1 {
            XConstraint.constant = mainNC.view.frame.width
            return
        }
    }
    
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        self.animationIsReversed = false
        let translation = gestureRecognizer.translation(in: view)
        var progress: CGFloat = 0
        if abs(translation.x) == 0 && abs(translation.y) == 0 && !(progressVerticalHasBegun || progressHorizontalHasBegun || isRolledUp) { return }
        verticalProgress = abs(translation.x) < abs(translation.y)
//        print("translation.y \(translation.y)")
//        print("translation.x \(translation.x)")
//        print("verticalProgress \(verticalProgress)")
        if (verticalProgress || progressVerticalHasBegun || isRolledUp) && !progressHorizontalHasBegun {
            progressVerticalHasBegun = true
            progress = (YConstraint.constant + translation.y - self.mainNC.navigationBar.frame.origin.y) / (tabbarOriginY - 80 - self.mainNC.navigationBar.frame.origin.y)
            if progress < 0 {
                progress = 0
                progressVerticalHasBegun = false
            } else if progress > 1 {
                progress = 1
            }
        } else if !verticalProgress || progressHorizontalHasBegun {
            progressHorizontalHasBegun = true
            progress = (XConstraint.constant + translation.x) / mainNC.view.frame.width
            if progress < 0 {
                progress = 0
                progressHorizontalHasBegun = false
            } else if progress > 1 {
                progress = 1
            }
        }
        switch gestureRecognizer.state {
            case .began, .changed:
                if (verticalProgress || progressVerticalHasBegun || isRolledUp) && !progressHorizontalHasBegun {
                    verticalProgressingMain(translation: translation, progress: progress)
                } else if !verticalProgress || progressHorizontalHasBegun {
                    horizontalProgress(translation: translation, progress: progress)
                }
                gestureRecognizer.setTranslation(CGPoint.zero, in: podcastNC.view)
            case .cancelled, .ended:
                if (verticalProgress || progressVerticalHasBegun || isRolledUp) && !progressHorizontalHasBegun {
                    if 1 - progress >= 0.5 {
                        self.closeAnimation(duration: defaultAnimationDuration * progress, duration2: defaultAnimationDuration * progress, close: false)
                    } else {
                        setAnimationDuration = defaultAnimationDuration * ( 1 - progress)
                        self.closeAnimation(duration: defaultAnimationDuration * ( 1 - progress), duration2: 0, close: true)
                    }
                } else if !verticalProgress || progressHorizontalHasBegun {
                    if 1 - progress >= 0.5 {
                        self.closeAnimationHorizontal(duration: 0.3 * progress, close: false)
                    } else {
                        self.closeAnimationHorizontal(duration: 0.3 * ( 1 - progress), close: true)
                    }
                }
                
                break
            default:
                break
        }
    }
    
    private func setRolledLayer(_ isRolled: Bool) {
        self.podcastVC.sliderViewLeadingConstraint.constant = isRolled ? self.view.frame.width + 20 : 30
        self.podcastVC.sliderViewTrailingConstraint.constant = isRolled ? 20 : 30
        self.podcastVC.closeButtonViewTrailingConstraint.constant = isRolled ? 80 + 20 - self.view.frame.width : 0
        self.podcastVC.closeButtonViewWidthContraint.constant = isRolled ? 60 : 0
        self.podcastVC.playButtonViewWidthConstraint.constant = isRolled ? 20 : 0
        self.podcastVC.podcastNameLabelCenterYConstraint.constant = -CGFloat(round(80 / 4))
        self.podcastVC.sliderViewCenterYConstraint.constant = isRolled ? CGFloat(round(80 / 4)) : 0
        self.mainNC.view.layoutIfNeeded()
        self.podcastVC.timeStackView.alpha = isRolled ? 0 : 1
        self.podcastVC.podcastNameLabel.alpha = isRolled ? 1 : 0
        self.isRolledLayerSet = isRolled
    }
    
    private func closeAnimation(duration: CGFloat, duration2: CGFloat, close: Bool, delay: CGFloat = 0) {
        let displayLink = CADisplayLink(target: self, selector: #selector(animationDidUpdate))
        displayLink.frameInterval = 1
        displayLink.add(to: RunLoop.main, forMode: RunLoop.Mode.default)
        UIView.animate(withDuration: TimeInterval(exactly: Double(duration))!, delay: 0.0, options: .curveEaseInOut, animations: {
            self.heightConstraint.constant = close ? 80 : self.mainNC.view.frame.height - self.mainNC.navigationBar.frame.origin.y
            self.YConstraint.constant = close ? self.tabbarOriginY - 80 : self.mainNC.navigationBar.frame.origin.y
            self.mainNC.view.layoutIfNeeded()
        }, completion: { (_) in
            displayLink.invalidate()
            self.animationIsReversed = false
            self.isRolledUp = close
            self.animationWasStarted = false
            self.progressVerticalHasBegun = false
        })
        if duration2 != 0 {
            UIView.animate(withDuration: TimeInterval(exactly: Double(duration2))!, delay: TimeInterval(exactly: Double(delay))!, options: .curveEaseInOut, animations: {
                self.podcastNC.navigationBar.alpha = close ? 0 : 1
                self.podcastVC.imageSize.constant = close ? self.view.frame.width : self.startImageWidth
                self.podcastVC.mainImageTopConstraint.constant = close ? 0 : self.startImageTop
                self.mainNC.view.layoutIfNeeded()
            }, completion: { (_) in
                
            })
        }
        self.startTime = CACurrentMediaTime()
    }
    
    private func closeAnimationHorizontal(duration: CGFloat, close: Bool) {
        UIView.animate(withDuration: TimeInterval(exactly: Double(duration))!, delay: 0.0, options: .curveEaseInOut, animations: {
            self.XConstraint.constant = close ? self.mainNC.view.frame.width : 0
            self.mainNC.view.layoutIfNeeded()
        }, completion: { (_) in
            if close {
                Player.instance.url = ""
                self.podcastView.removeFromSuperview()
            }
            self.progressHorizontalHasBegun = false
        })
    }
    
    private func calculateTime(currentValue: CGFloat, startValue: CGFloat, change : CGFloat, duration: CGFloat) -> CGFloat {
        let time = (2 * (currentValue - startValue) / change).squareRoot()
        return duration * time / 2
    }
    
    @objc func animationDidUpdate(displayLink: CADisplayLink) {
        guard let height = self.podcastView.layer.presentation()?.frame.height else { return }
        guard let originY = self.podcastView.layer.presentation()?.frame.origin.y else { return }
        if height <= 200 && !animationWasStarted {
            self.animationWasStarted = true
            if !self.animationIsReversed {
                if !isRolledLayerSet { self.setRolledLayer(true) }
                let duration: CGFloat = setAnimationDuration != nil ? setAnimationDuration! : defaultAnimationDuration
                //let duration: CGFloat = 4
                UIView.animate(withDuration: Double(duration) - (CACurrentMediaTime() - startTime), delay: 0, options: .curveEaseInOut, animations: {
                    self.podcastVC.mainImageCenterXConstraint.constant = 40 - self.mainNC.view.frame.width / 2
                    self.podcastVC.mainImageHeightConstraint.constant = 80
                    self.podcastVC.imageSize.constant = !self.animationIsReversed ? 80 : self.view.frame.width
                    self.podcastVC.sliderViewLeadingConstraint.constant = 80 + 20
                    self.podcastVC.closeButtonViewTrailingConstraint.constant = 0
                    self.mainNC.view.layoutIfNeeded()
                }, completion: { (_) in
                    print("self.podcastVC.view.frame \(self.podcastVC.view.frame)")
                    print("podcastNC \(self.podcastNC.view.frame)")
                })
            }
        }
        tabbar.tabBar.frame.origin.y = originY + height
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
        cell.separatorView.isHidden = indexPath.row == 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.podcastView.removeFromSuperview()
        Player.instance.pause()
//        DispatchQueue.global().async {
//            Player.instance.pause()
//        }
        //self.podcastVC.closeTest()
        //print("111")
        self.addPodcastView()
        //print("222")
        self.podcastVC.audioSource = "https://firebasestorage.googleapis.com/v0/b/kinoogon-85687.appspot.com/o/podcasts%2F2019-01-04%2011.19.06.mp3?alt=media&token=4ffff425-38b0-48ef-9cce-939d45fe693e"
        //print("333")
        self.mainNC.view.layoutIfNeeded()
        self.setRolledLayer(false)
        self.setStartValues()
        self.mainNC.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.XConstraint.constant = 0
            self.mainNC.view.layoutIfNeeded()
        }, completion: { _ in
            
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 81
    }
}

extension SoundCloudVC: PodcastDelegate {
    func rollPodcast() {
        setAnimationDuration = nil
        self.closeAnimation(duration: defaultAnimationDuration, duration2: defaultAnimationDuration / 2, close: true)
    }
    
    func closePodcast() {
        Player.instance.url = ""
        self.podcastView.removeFromSuperview()
    }
}
