//
//  YouTubeListVC.swift
//  Kinoogon
//
//  Created by Sultan Karybaev on 11/26/18.
//  Copyright © 2018 Sultan Karybaev. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

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
    
    private var youtubeArray: [YouTubeVideo] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private var imageArray: [Int : Data] = [:]
    
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
        
        getYouTubeVideoIDs()
        
        playerView = UINib(nibName: "PlayerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? PlayerView
        //playerView.videoId = "qPiWhL9-Nvw"
        playerView.rootVC = self
        
        L1 = playerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0)
        L2 = playerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0)
        L3 = playerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0)
        L4 = playerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        
        P1 = playerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        P2 = playerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        if #available(iOS 11.0, *) {
            P3 = playerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -self.view.frame.width / 16 * 9)
        } else {
            P3 = playerView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor, constant: -self.view.frame.width / 16 * 9)
        }
        P4 = playerView.heightAnchor.constraint(equalToConstant: self.view.frame.width / 16 * 9)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
        super.viewDidAppear(animated)
        addPlayerView()
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
    
    private func getYouTubeVideoIDs() {
        DispatchQueue.global().async {
            Alamofire.request("\(SMACK_SERVER)\(KINOOGON_API)").responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    guard let data = json["videoidArray"].array else { return }
                    var YVArray: [YouTubeVideo] = []
                    for i in 0...data.count - 1 {
                        guard let videoTitle = data[i]["title"].string else { return }
                        guard let videoImage = data[i]["image"].string else { return }
                        guard let videoId = data[i]["id"].string else { return }
                        let yv = YouTubeVideo.init(image: videoImage, title: videoTitle, id: videoId)
                        YVArray.append(yv)
                    }
                    self.youtubeArray = YVArray
                case .failure(let error):
                    print(error)
                    return
                }
            })
        }
    }
    
}

extension YouTubeListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return youtubeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTableCell") as? YoutubeCell else {
            return YoutubeCell()
        }
        cell.tag = indexPath.row
        cell.setTitle(title: youtubeArray[indexPath.row].title)
        if imageArray[indexPath.row] == nil {
            DispatchQueue.global().async {
                do {
                    let data = try Data(contentsOf: URL(string: self.youtubeArray[indexPath.row].image)!)
                    DispatchQueue.main.async {
                        if (cell.tag == indexPath.row) {
                            cell.setImage(data: data)
                            cell.setNeedsLayout()
                        }
                        self.imageArray[indexPath.row] = data
                    }
                } catch let error {
                    debugPrint("YouTubeListVC.swift \(error)")
                }
            }
        } else {
            cell.setImage(data: imageArray[indexPath.row]!)
        }
        
        
        cell.configureCell(view: self.view, id: youtubeArray[indexPath.row].id)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        playerView.videoId = youtubeArray[indexPath.row].id
        UIView.animate(withDuration: 0.5, animations: {
            self.P3.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
}
