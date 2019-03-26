//
//  CommonTableCell.swift
//  Kinoogon
//
//  Created by Sultan Karybaev on 11/29/18.
//  Copyright © 2018 Sultan Karybaev. All rights reserved.
//

import UIKit
import WebKit

class YoutubeCell: UITableViewCell {

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var boxView: UIView!
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    
    public var web: WKWebView!
    public var videoId: String = ""
    public var isWebSet = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awakeFromNib")
        mainImage.layer.cornerRadius = 10
        viewHeightConstraint.constant = (self.frame.width - 20) / 16 * 9
        imageHeight.constant = (self.frame.width - 20) / 16 * 9
        //boxView.isHidden = false
    }
    
    func configureCell(id: String, title: String) {
        print("configureCell \(titleLabel.text == title) \(id)")
        videoId = id
        titleLabel.text = title
//        if !self.isWebSet {
//            guard let url = URL(string: "https://youtube.com/embed/\(videoId)?autoplay=1&playsinline=1&modestbranding=1") else { return }
//            self.web.load(URLRequest(url: url))
//            titleLabel.text = title
//            self.isWebSet = true
//        }
        
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
    }
    
    func setImage(data: Data) {
        mainImage.image = UIImage(data: data)
    }
    
    public func activateVideo() {
        
    }

    

}
