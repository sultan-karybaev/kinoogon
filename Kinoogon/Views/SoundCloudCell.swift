//
//  SoundCloudCell.swift
//  Kinoogon
//
//  Created by Sultan Karybaev on 11/25/18.
//  Copyright © 2018 Sultan Karybaev. All rights reserved.
//

import UIKit

class SoundCloudCell: UITableViewCell {
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImage.layer.cornerRadius = 10
        iconImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
