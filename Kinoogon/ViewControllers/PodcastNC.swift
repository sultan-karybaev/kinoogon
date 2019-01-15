//
//  PodcastNC.swift
//  Kinoogon
//
//  Created by Sultan Karybaev on 11/24/18.
//  Copyright © 2018 Sultan Karybaev. All rights reserved.
//

import UIKit

class PodcastNC: UINavigationController {
    //var interactor: TransitionInteractor!
    var interactor: CustomViewControllerAnimator!
    //var interactor: Interactive!
    var progress: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        transitioningDelegate = self
        //interactor = TransitionInteractor()
        interactor = CustomViewControllerAnimator(durationX: 6, isPresenting: false)
        //interactor = Interactive(durationX: 3, isPresenting: false)
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        //self.view.addGestureRecognizer(gesture)
    }
    
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        //print("\(self.view.layer.presentation()?.frame)")
        let translation = gestureRecognizer.translation(in: view)
        //let horizontalMovement = translation.x / view.bounds.width
        let horizontalMovement = translation.y / view.bounds.height
        let downwardMovement = fmaxf(Float(horizontalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        progress = CGFloat(downwardMovementPercent)
        
        switch gestureRecognizer.state {
        case .began:
            interactor.hasStarted = true
            dismiss(animated: true, completion: nil)
        case .changed:
            interactor.shouldFinish = progress > 0.4
            interactor.update(progress)
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish ? interactor.finish() : interactor.cancel()
        default:
            break
        }
    }

}

extension PodcastNC: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            return CustomViewControllerAnimator(durationX: 0.2, isPresenting: true)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return interactor
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}
