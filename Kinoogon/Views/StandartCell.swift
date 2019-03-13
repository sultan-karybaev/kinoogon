//
//  StandartCell.swift
//  Kinoogon
//
//  Created by Sultan Karybaev on 2/14/19.
//  Copyright © 2019 Sultan Karybaev. All rights reserved.
//

import UIKit

class StandartCell: UITableViewCell {
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var separatorView: UIView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //descriptionLabel.text = "label"
        mainImage.layer.cornerRadius = 10
        //imageHeight.constant = mainImage.frame.width
        imageHeight.constant = (contentView.frame.width - 20) / 16 * 9
    }

}
