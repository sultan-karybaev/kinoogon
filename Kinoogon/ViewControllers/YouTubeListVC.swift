//
//  YouTubeListVC.swift
//  Kinoogon
//
//  Created by Sultan Karybaev on 11/26/18.
//  Copyright © 2018 Sultan Karybaev. All rights reserved.
//

import UIKit
//import You

class YouTubeListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var L1: NSLayoutConstraint!
    private var L2: NSLayoutConstraint!
    private var L3: NSLayoutConstraint!
    private var L4: NSLayoutConstraint!
    
    private var P1: NSLayoutConstraint!
    private var P2: NSLayoutConstraint!
    private var P3: NSLayoutConstraint!
    private var P4: NSLayoutConstraint!
    
    
    private var playerView: PlayerView!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
    
    override var shouldAutorotate: Bool{
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        
        playerView = UINib(nibName: "PlayerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? PlayerView
        //playerView.videoId = "qPiWhL9-Nvw"
        playerView.rootVC = self
        
        L1 = playerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0)
        L2 = playerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0)
        L3 = playerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0)
        L4 = playerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        
        let guide = view.safeAreaLayoutGuide
        P1 = playerView.leadingAnchor.constraint(equalTo: guide.leadingAnchor)
        P2 = playerView.trailingAnchor.constraint(equalTo: guide.trailingAnchor)
        P3 = playerView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 0)
        P4 = playerView.heightAnchor.constraint(equalToConstant: self.view.frame.width / 16 * 9)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
        super.viewDidAppear(animated)
        //addPlayerView()
    }
    
    private func addPlayerView(){
        self.view.addSubview(playerView)
        playerView.translatesAutoresizingMaskIntoConstraints = false
        
        P1.isActive = true
        P2.isActive = true
        P3.isActive = true
        P4.isActive = true
        
        playerView.autoresizingMask = .flexibleWidth
    }
    
    func landscape() {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        P1.isActive = false
        P2.isActive = false
        P3.isActive = false
        P4.isActive = false
        L1.isActive = true
        L2.isActive = true
        L3.isActive = true
        L4.isActive = true
    }
    
    func portrait() {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        P1.isActive = true
        P2.isActive = true
        P3.isActive = true
        P4.isActive = true
        L1.isActive = false
        L2.isActive = false
        L3.isActive = false
        L4.isActive = false
    }
    
    private func getYouTubeData() {
        DispatchQueue.global().async {
            
        }
    }

}

extension YouTubeListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTableCell") as? CommonTableCell else {
            return CommonTableCell()
        }
        cell.configureCell(view: self.view)
        if indexPath.row == 0 {
            cell.separatorView.isHidden = true
        } else {
            cell.separatorView.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}
