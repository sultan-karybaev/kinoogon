//
//  TopListVC.swift
//  Kinoogon
//
//  Created by Sultan Karybaev on 12/2/18.
//  Copyright © 2018 Sultan Karybaev. All rights reserved.
//

import UIKit
import WebKit

class TopListVC: UIViewController {

    @IBOutlet weak var uiview: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let webConfiguration = WKWebViewConfiguration()
        //webConfiguration.
        webConfiguration.allowsInlineMediaPlayback = true
        if #available(iOS 10.0, *) {
            webConfiguration.mediaTypesRequiringUserActionForPlayback = []
        }
        let web = WKWebView(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.width / 16 * 9), configuration: webConfiguration)
        view.addSubview(web)
        //let url = URL(string: "https://youtube.com/embed/RmHqOSrkZnk?playsinline=1&rel=0&hd=1&showinfo=0&enablejsapi=1")!
        let url = URL(string: "https://youtube.com/embed/RmHqOSrkZnk?autoplay=1&playsinline=1&modestbranding=1")!
        web.load(URLRequest(url: url))
        //web.loadHTMLString("<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/d-bw5eV8BdY\" frameborder=\"0\" allow=\"accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture\" allowfullscreen></iframe>", baseURL: nil)
        
        
       
    }

}
