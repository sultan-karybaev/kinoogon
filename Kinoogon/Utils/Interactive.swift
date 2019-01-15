//
//  CustomViewControllerAnimator.swift
//  Kinoogon
//
//  Created by Sultan Karybaev on 11/24/18.
//  Copyright © 2018 Sultan Karybaev. All rights reserved.
//

import UIKit
//UIViewControllerInteractiveTransitioning


final class Interactive: UIPercentDrivenInteractiveTransition {
    var hasStarted = false
    var shouldFinish = false
    
    
    var durationX : TimeInterval
    var isPresenting : Bool
        
    init(durationX : TimeInterval, isPresenting : Bool) {
        self.durationX = durationX
        self.isPresenting = isPresenting
    }
    
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to),
            let snapshot = isPresenting ? toVC.view.snapshotView(afterScreenUpdates: true) : fromVC.view.snapshotView(afterScreenUpdates: false)
            else { return  }
        
        let podcastListView = isPresenting ? fromVC : toVC
        let podcastView = isPresenting ? toVC : fromVC
        
        let containerView = transitionContext.containerView
        //let finalFrame = transitionContext.finalFrame(for: toVC)
        print("toVC \(toVC)")
        var center: CGFloat = 0
        var start: CGFloat = 0
        var podcastNC: PodcastNC?
        var podcastVC: PodcastVC?
        if isPresenting {
            start = podcastListView.view.frame.width + podcastView.view.frame.width / 2
            center = podcastListView.view.center.x
            
            snapshot.center.x = isPresenting ? start : center
            
            podcastView.view.center.x = isPresenting ? start : center
        } else {
            start = podcastListView.view.frame.height + podcastView.view.frame.height / 2
            center = podcastListView.view.center.y
            
            snapshot.center.y = isPresenting ? start : center
            
            podcastView.view.center.y = isPresenting ? start : center
            podcastNC = fromVC as? PodcastNC
            podcastVC = podcastNC!.viewControllers[0] as? PodcastVC
            
        }
        
        
        containerView.addSubview(toVC.view)
        containerView.bringSubviewToFront(podcastView.view)
        
        
        print("11111111111111111")
        //podcastVC!.view.layer.presentation()?.frame
        //containerView.addSubview(snapshot)
        
        //            let a = UIViewPropertyAnimator(duration: self.durationX, curve: .linear, animations: {
        //                if self.isPresenting {
        //                    podcastView.view.center.x = self.isPresenting ? center : start
        //                } else {
        //                    print("11111111111111111")
        //                    podcastNC!.view.center.y = self.isPresenting ? center : podcastListView.view.frame.height
        //                    podcastNC!.navigationBar.alpha = 0
        //                    //podcastView.view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        //                    podcastVC!.view.frame = CGRect(x: 0, y: 0, width: podcastVC!.view.frame.width, height: 100)
        //                    //podcastVC!.imageSize.constant = podcastListView.view.frame.width
        //                    //podcastVC!.view.layoutIfNeeded()
        //                }
        //            })
        //            a.addCompletion { (_) in
        //                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        //            }
        //        let observationToken = a.observe(\.isRunning) { animator, change in
        //            print("observationToken")
        //        }
        //        observationToken.invalidate()
        //            return a
        
        UIView.animate(
            withDuration: TimeInterval(exactly: 6)!,
            animations: {
                if self.isPresenting {
                    podcastView.view.center.x = self.isPresenting ? center : start
                } else {
                    print("11111111111111111")
                    podcastNC!.view.center.y = self.isPresenting ? center : podcastListView.view.frame.height
                    podcastNC!.navigationBar.alpha = 0
                    //podcastView.view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
                    podcastVC!.view.frame = CGRect(x: 0, y: 0, width: podcastVC!.view.frame.width, height: 100)
                    //podcastVC!.imageSize.constant = podcastListView.view.frame.width
                    //podcastVC!.view.layoutIfNeeded()
                }
                
        },
            completion: { _ in
                print("completion")
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                if !self.isPresenting {podcastVC!.imageSize.constant = 160}
                //                guard let mainNC = toVC as? MainNC else { return }
                //                let tab = mainNC.viewControllers[0]
                //                let v = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
                //                v.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                //                print("v \(v)")
                //                tab.view.addSubview(v)
        })
        let displayLink = CADisplayLink(target: self, selector: #selector(animationDidUpdate))
        displayLink.frameInterval = 3
        displayLink.add(to: RunLoop.main, forMode: RunLoop.Mode.default)
        
        //        UIView.animate(
        //            withDuration: TimeInterval(exactly: 1)!,
        //            animations: {
        //                if self.isPresenting {
        //                    //podcastView.view.center.x = self.isPresenting ? center : start
        //                } else {
        //                    podcastVC!.imageSize.constant = podcastListView.view.frame.width
        //                    podcastVC!.view.layoutIfNeeded()
        //                }
        //        },
        //            completion: { _ in
        //                print("completion")
        //                displayLink.invalidate()
        //                UIView.animate(withDuration: TimeInterval(exactly: 1)!, animations: {
        //                    if self.isPresenting {
        //                        //podcastView.view.center.x = self.isPresenting ? center : start
        //                    } else {
        //                        podcastVC!.imageSize.constant = 160
        //                        podcastVC!.view.layoutIfNeeded()
        //                    }
        //                })
        //        })
        
        UIView.animateKeyframes(withDuration: 2, delay: 0, options: [.autoreverse, .repeat], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                if !self.isPresenting {
                    podcastVC!.imageSize.constant = podcastListView.view.frame.width
                    podcastVC!.view.layoutIfNeeded()
                }
            })
            UIView.addKeyframe(withRelativeStartTime: 1, relativeDuration: 1, animations: {
                if !self.isPresenting {
                    podcastVC!.imageSize.constant = 160
                    podcastVC!.view.layoutIfNeeded()
                }
            })
        }, completion: nil)
        
        //        [UIView, animateKeyframesWithDuration:2.0 delay:0.0 options:UIViewKeyframeAnimationOptionAutoreverse | UIViewKeyframeAnimationOptionRepeat animations:^{
        //            [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5 animations:^{
        //            topConstraint.constant = 200;
        //            leftConstraint.constant = 200;
        //            [self.view layoutIfNeeded];
        //            }];
        //            [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
        //            topConstraint.constant = 100;
        //            leftConstraint.constant = 300;
        //            [self.view layoutIfNeeded];
        //            }];
        //            } completion:nil];
    }
    
    @objc func animationDidUpdate(displayLink: CADisplayLink) {
        //print("animationDidUpdate \(percentComplete) \(duration)")
    }
    
}
