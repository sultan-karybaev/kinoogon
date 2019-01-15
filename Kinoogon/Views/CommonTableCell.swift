//
//  CommonTableCell.swift
//  Kinoogon
//
//  Created by Sultan Karybaev on 11/29/18.
//  Copyright © 2018 Sultan Karybaev. All rights reserved.
//

import UIKit

class CommonTableCell: UITableViewCell {

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var videoId: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainImage.layer.cornerRadius = 10
    }
    
    func configureCell(view: UIView, id: String) {
        imageHeight.constant = (view.frame.width - 20) / 16 * 9
        videoId = id
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
    }
    
    func setImage(data: Data) {
        mainImage.image = UIImage(data: data)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
