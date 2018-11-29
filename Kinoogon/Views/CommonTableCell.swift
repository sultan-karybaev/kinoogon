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
    //private var rootView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //print("self.superview \(self.superview)")
        //imageHeight.constant = (rootView.frame.width - 20) / 16 * 9
        mainImage.layer.cornerRadius = 10
    }
    
    func configureCell(view: UIView) {
        //rootView = view
        imageHeight.constant = (view.frame.width - 20) / 16 * 9
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
