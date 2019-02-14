//
//  MainNC.swift
//  Kinoogon
//
//  Created by Sultan Karybaev on 1/10/19.
//  Copyright © 2019 Sultan Karybaev. All rights reserved.
//

import UIKit

class MainNC: UINavigationController {

    private var tabbar: UITabBarController!
    
    public var startImageWidth: CGFloat?
    public var startImageTop: CGFloat?
    public var startImageHeight: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabbar = self.viewControllers[0] as? UITabBarController
        
        //test
        DataService.instance.asd()
    }

    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard let soundcloudVC = tabbar.selectedViewController as? SoundCloudVC else { return }
        soundcloudVC.bottomSafeAreaConstraint.constant -= self.view.frame.height - tabbar.tabBar.frame.origin.y
        tabbar.tabBar.frame.origin.y = self.view.frame.height
    }

}
