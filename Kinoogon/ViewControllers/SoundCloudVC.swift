//
//  SoundCloudVC.swift
//  Kinoogon
//
//  Created by Sultan Karybaev on 11/22/18.
//  Copyright © 2018 Sultan Karybaev. All rights reserved.
//

import UIKit
import AVFoundation

class SoundCloudVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    let radio = "http://strm112.1.fm/acountry_mobile_mp3"
    
    private var leftBarButtonItem : UIBarButtonItem!
    
    //left button.
    private var navigationLeftButton : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.navigationItem.title = "Подкасты"
//        tabBarController?.navigatio
//        UITabBarController.app
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.separatorColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 1)
        tableView.bounces = false
        tableView.backgroundView = nil
        tableView.backgroundColor = #colorLiteral(red: 0.0862745098, green: 0.1294117647, blue: 0.1803921569, alpha: 1)
        tableView.layer.backgroundColor = #colorLiteral(red: 0.0862745098, green: 0.1294117647, blue: 0.1803921569, alpha: 1)
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        
    }
    
    
    
    
    
}

extension SoundCloudVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SoundCloudCell") as? SoundCloudCell else {
            return SoundCloudCell()
        }
        //print(indexPath.row)
        if indexPath.row == 0 {
            cell.separatorView.isHidden = true
        } else {
            cell.separatorView.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PodcastNC")
        tableView.deselectRow(at: indexPath, animated: true)
        present(vc!, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 81
    }
}
