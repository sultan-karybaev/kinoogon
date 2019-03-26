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
import WebKit

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
    private var dataDictionary: [String : Data] = [:]
    private var currentIndexPath: IndexPath? = nil
    
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
        
        getData()
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        if #available(iOS 10.0, *) {
            webConfiguration.mediaTypesRequiringUserActionForPlayback = []
        }
        self.webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), configuration: webConfiguration)
        //test()
        //getYouTubeVideoIDs()
        
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
        //addPlayerView()
        setNavigation()
    }
    
    private func setNavigation() {
        //title = "asd"
        self.navigationController?.navigationBar.topItem?.title = "YouTube канал"
//        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        //tabBarController?.navigationItem.title = "YouTube канал"
        //let textAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        //self.navigationController?.navigationBar.titleTextAttributes = textAttributes
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
    
    private func getData() {
        DataService.instance.getYouTubeVideo { (success) in
            if success {
                self.youtubeArray = DataService.instance.YOUTUBE_ARRAY
            }
        }
        
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
    
    private func addWebView(videoId: String) {
        let webConfiguration = WKWebViewConfiguration()
        //webConfiguration.
        webConfiguration.allowsInlineMediaPlayback = true
        if #available(iOS 10.0, *) {
            webConfiguration.mediaTypesRequiringUserActionForPlayback = []
        }
        let web = WKWebView(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.width / 16 * 9), configuration: webConfiguration)
        view.addSubview(web)
        //let url = URL(string: "https://youtube.com/embed/RmHqOSrkZnk?playsinline=1&rel=0&hd=1&showinfo=0&enablejsapi=1")!
        let url = URL(string: "https://youtube.com/embed/\(videoId)?autoplay=1&playsinline=1&modestbranding=1")!
        web.load(URLRequest(url: url))
        //web.loadHTMLString("<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/d-bw5eV8BdY\" frameborder=\"0\" allow=\"accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture\" allowfullscreen></iframe>", baseURL: nil)
    }
    
    func test() {
        //guard let url = URL(string: "https://r.mradx.net/pictures/D2/DE81ED.jpg") else { return }
        guard let url = URL(string: "https://youtube.com/embed/GZQIntBz2eI?autoplay=1&playsinline=1&modestbranding=1") else { return }
        let f = URLRequest(url: url)
        //url
        let task = URLSession.shared.dataTask(with: f) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse, let contentType = httpResponse.allHeaderFields["Content-Type"] as? String {
                // use contentType here
                print("contentType \(contentType)")
            }
            guard let data = data else { return }
            do {
                let data2 = try Data(contentsOf: url)
                //data.
                let mime = self.mimeType(for: data2)
                let mime2 = self.mimeType(for: data)
                print("mimeType \(mime) \(data2 == data)")
            } catch {
                
            }
        }
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            if let httpResponse = response as? HTTPURLResponse, let contentType = httpResponse.allHeaderFields["Content-Type"] as? String {
//                // use contentType here
//                print("contentType \(contentType)")
//            }
//        }
        task.resume()
        
        
    }
    
    func mimeType(for data: Data) -> String {
        
        var b: UInt8 = 0
        data.copyBytes(to: &b, count: 1)
        print("data.copyBytes \(b)")
        switch b {
        case 0xFF:
            return "image/jpeg"
        case 0x89:
            return "image/png"
        case 0x47:
            return "image/gif"
        case 0x4D, 0x49:
            return "image/tiff"
        case 0x25:
            return "application/pdf"
        case 0xD0:
            return "application/vnd"
        case 0x46:
            return "text/plain"
        default:
            return "application/octet-stream"
        }
    }
    
    private var webView: WKWebView!
    
    func addWeb(boxView: UIView) {
        
        //self.web.removeFromSuperview()
        //self.web.loadHTMLString("<html><head></head><body></body></html>", baseURL: nil)
        boxView.addSubview(self.webView)
        
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: boxView, attribute: .top, relatedBy: .equal, toItem: self.webView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: boxView, attribute: .leading, relatedBy: .equal, toItem: self.webView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: boxView, attribute: .trailing, relatedBy: .equal, toItem: self.webView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: boxView, attribute: .bottom, relatedBy: .equal, toItem: self.webView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }
    
}

extension YouTubeListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return youtubeArray.count
        //return youtubeArray.count > 0 ? 2 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellForRowAt")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTableCell") as? YoutubeCell else {
            return YoutubeCell()
        }
        let youtubeVideo = youtubeArray[indexPath.row]
        cell.boxView.isHidden = currentIndexPath != indexPath
        if let data = dataDictionary[youtubeVideo.image] {
            print("dataDictionary")
            cell.mainImage.image = UIImage(data: data)
        } else {
            print("DownloadService")
            cell.mainImage.image = nil
            DownloadService.getImage(indexPath: indexPath, path: youtubeVideo.image) { (success, ind, data) in
                if success {
                    guard let cell = tableView.cellForRow(at: ind) as? YoutubeCell else { return }
                    cell.mainImage.image = UIImage(data: data)
                    self.dataDictionary[youtubeVideo.image] = data
                }
            }
        }
        cell.configureCell(id: youtubeArray[indexPath.row].id, title: youtubeVideo.title)
        cell.separatorView.isHidden = indexPath.row == 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let current = currentIndexPath {
            //self.webView.reload()
            currentIndexPath = indexPath
            tableView.reloadRows(at: [current], with: .none)
        }
        currentIndexPath = indexPath
        guard let cell = tableView.cellForRow(at: indexPath) as? YoutubeCell else { return }
        cell.boxView.isHidden = false
        self.addWeb(boxView: cell.boxView)
        guard let url = URL(string: "https://youtube.com/embed/\(cell.videoId)?autoplay=1&playsinline=1&modestbranding=1") else { return }
        self.webView.load(URLRequest(url: url))
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
        //addWebView(videoId: youtubeArray[indexPath.row].id)
//        playerView.videoId = youtubeArray[indexPath.row].id
//        UIView.animate(withDuration: 0.5, animations: {
//            self.P3.constant = 0
//            self.view.layoutIfNeeded()
//        })
    }
    
}
