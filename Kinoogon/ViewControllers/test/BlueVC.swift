//
//  BlueVC.swift
//  Kinoogon
//
//  Created by Sultan Karybaev on 3/6/19.
//  Copyright © 2019 Sultan Karybaev. All rights reserved.
//

import UIKit

class BlueVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear BlueVC \(self.presentedViewController) \(self.presentingViewController)")
    }

}
