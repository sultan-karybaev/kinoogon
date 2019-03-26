//
//  DownloadService.swift
//  Kinoogon
//
//  Created by Sultan Karybaev on 2/14/19.
//  Copyright © 2019 Sultan Karybaev. All rights reserved.
//

import Foundation

final class DownloadService {
    public static func getImage(indexPath: IndexPath, path: String, handler: @escaping( (Bool, IndexPath, Data) -> () )) {
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: URL(string: path)!)
                DispatchQueue.main.async {
                    handler(true, indexPath, data)
                }
            } catch let error {
                debugPrint("DownloadService.swift \(error.localizedDescription)")
            }
        }
    }
    
    public static func getURL(indexPath: IndexPath, videoId: String, handler: @escaping( (Bool, IndexPath, URL) -> () )) {
        DispatchQueue.global().async {
            if let url = URL(string: "https://youtube.com/embed/\(videoId)?autoplay=1&playsinline=1&modestbranding=1") {
                DispatchQueue.main.async {
                    handler(true, indexPath, url)
                }
            } else {
                //handler(false, indexPath, URL())
            }
        }
    }
}
