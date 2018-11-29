//
//  UIButton.swift
//  Kinoogon
//
//  Created by Sultan Karybaev on 11/28/18.
//  Copyright © 2018 Sultan Karybaev. All rights reserved.
//

import UIKit

extension UIButton {
    
    func setIconImage(imageName: String) {
        let icon = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        self.setImage(icon, for: .normal)
        self.imageView?.contentMode = .scaleAspectFit
        self.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
}
