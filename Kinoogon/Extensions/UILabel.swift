//
//  UILabel.swift
//  Kinoogon
//
//  Created by Sultan Karybaev on 11/28/18.
//  Copyright © 2018 Sultan Karybaev. All rights reserved.
//

import UIKit

extension UILabel {
    
    func setTime(time: Double) {
        let hour = Int(floor(time / 3600))
        let minutes = Int(floor(time.truncatingRemainder(dividingBy: 3600) / 60))
        let seconds = Int(floor(time.truncatingRemainder(dividingBy: 60)))
        var labelMinutes = ""
        if minutes < 10 {
            labelMinutes = "0\(minutes)"
        } else {
            labelMinutes = "\(minutes)"
        }
        var labelSeconds = ""
        if seconds < 10 {
            labelSeconds = "0\(seconds)"
        } else {
            labelSeconds = "\(seconds)"
        }
        text = "\(hour) : \(labelMinutes) : \(labelSeconds)"
    }
    
}
