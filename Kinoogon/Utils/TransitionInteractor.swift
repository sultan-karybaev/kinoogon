//
//  TransitionInteractor.swift
//  Kinoogon
//
//  Created by Sultan Karybaev on 11/24/18.
//  Copyright © 2018 Sultan Karybaev. All rights reserved.
//

import UIKit

class TransitionInteractor: UIPercentDrivenInteractiveTransition {
    var hasStarted = false
    var shouldFinish = false
    
    override func update(_ percentComplete: CGFloat) {
        super.update(percentComplete)
        //print("update")
    }
}
