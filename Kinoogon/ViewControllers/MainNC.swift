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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //print("MainNC \(self.viewControllers)")
        tabbar = self.viewControllers[0] as! UITabBarController
//        let v = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
//        v.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        tab.view.addSubview(v)
    }
    
    //@available(iOS 11.0, *)
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear \(tabbar.tabBar.frame)")
        if #available(iOS 11.0, *) {
            print("tabbar.additionalSafeAreaInsets \(tabbar.additionalSafeAreaInsets)")
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        guard let soundcloudVC = tabbar.selectedViewController as? SoundCloudVC else { return }
        soundcloudVC.bottomSafeAreaConstraint.constant -= self.view.frame.height - tabbar.tabBar.frame.origin.y
        tabbar.tabBar.frame.origin.y = self.view.frame.height
        
    }

}
