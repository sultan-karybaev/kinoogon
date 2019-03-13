//
//  TableVC.swift
//  Kinoogon
//
//  Created by Sultan Karybaev on 2/21/19.
//  Copyright © 2019 Sultan Karybaev. All rights reserved.
//

import UIKit

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

class ProfileVC: UIViewController {
    
    public var hostName: String!
    public var hostID: String!
    private var picturesArray: [InfoModel] = [InfoModel]()
    private var tableVC: StandartTVC!
    
    private var percentDrivenInteractiveTransition: UIPercentDrivenInteractiveTransition!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTableView()
        self.tableVC.hostID = hostID
        setData()
        addGesture()
    }
    
    private func setData() {
        let picturesArrayOrNull = DataService.instance.HOSTS_PICTURES_DICTIONARY[hostID]
        if picturesArrayOrNull == nil {
            getData()
        } else {
            picturesArray = picturesArrayOrNull!
            if picturesArray.isEmpty {
                getData()
            } else {
                self.tableVC.infoModelArray = self.picturesArray
                self.tableVC.tableView.reloadData()
            }
        }
    }
    
    private func getData() {
        DataService.instance.getHostsPictures(hostID: hostID) { (success) in
            if success {
                guard let picturesArray = DataService.instance.HOSTS_PICTURES_DICTIONARY[self.hostID] else { return }
                self.picturesArray = picturesArray
                self.tableVC.infoModelArray = self.picturesArray
                self.tableVC.tableView.reloadData()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }
    
    private func setNavigationBar() {
        title = hostName
        let textAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    private func addTableView() {
        guard let standartTVC = storyboard?.instantiateViewController(withIdentifier: "StandartTVC") as? StandartTVC else { return }
        standartTVC.hostID = hostID
        tableVC = standartTVC
        addChild(standartTVC)
        self.view.addSubview(standartTVC.view)
        standartTVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: standartTVC.view, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: standartTVC.view, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: standartTVC.view, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: standartTVC.view, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }
    
    func addGesture() {
        
        guard navigationController?.viewControllers.count > 1 else {
            return
        }
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        self.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func handlePanGesture(_ panGesture: UIPanGestureRecognizer) {
        
        let percent = max(panGesture.translation(in: view).x, 0) / view.frame.width
        
        switch panGesture.state {
            
        case .began:
            navigationController?.delegate = self
            _ = navigationController?.popViewController(animated: true)
            
        case .changed:
            if let percentDrivenInteractiveTransition = percentDrivenInteractiveTransition {
                percentDrivenInteractiveTransition.update(percent)
            }
            
        case .ended:
            let velocity = panGesture.velocity(in: view).x
            
            // Continue if drag more than 50% of screen width or velocity is higher than 1000
            if percent > 0.5 || velocity > 1000 {
                percentDrivenInteractiveTransition.finish()
            } else {
                percentDrivenInteractiveTransition.cancel()
            }
            
        case .cancelled, .failed:
            percentDrivenInteractiveTransition.cancel()
            
        default:
            break
        }
    }
    
}

extension ProfileVC: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return SlideAnimatedTransitioning()
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        navigationController.delegate = nil
        
        if panGestureRecognizer.state == .began {
            percentDrivenInteractiveTransition = UIPercentDrivenInteractiveTransition()
            percentDrivenInteractiveTransition.completionCurve = .easeOut
        } else {
            percentDrivenInteractiveTransition = nil
        }
        
        return percentDrivenInteractiveTransition
    }
}


