//
//  CustomViewControllerAnimator.swift
//  Kinoogon
//
//  Created by Sultan Karybaev on 11/24/18.
//  Copyright © 2018 Sultan Karybaev. All rights reserved.
//

import UIKit

final class CustomViewControllerAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var duration : TimeInterval
    var isPresenting : Bool
    
    init(duration : TimeInterval, isPresenting : Bool) {
        self.duration = duration
        self.isPresenting = isPresenting
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to),
            let snapshot = isPresenting ? toVC.view.snapshotView(afterScreenUpdates: true) : fromVC.view.snapshotView(afterScreenUpdates: false)
            else { return }
        
        let podcastListView = isPresenting ? fromVC : toVC
        let podcastView = isPresenting ? toVC : fromVC

        let containerView = transitionContext.containerView
        //let finalFrame = transitionContext.finalFrame(for: toVC)
        
        let startX = podcastListView.view.frame.width + podcastView.view.frame.width / 2
        let centerX = podcastListView.view.center.x
        
        snapshot.center.x = isPresenting ? startX : centerX
        
        podcastView.view.center.x = isPresenting ? startX : centerX
//        if isPresenting {containerView.addSubview(podcastView.view)}
//        else {containerView.insertSubview(podcastListView.view, at: 10)}
        containerView.addSubview(toVC.view)
        containerView.bringSubviewToFront(podcastView.view)
        
        
        //containerView.addSubview(snapshot)
        
        UIView.animate(
            withDuration: self.duration,
            animations: {
                podcastView.view.center.x = self.isPresenting ? centerX : startX
        },
            completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    
}
