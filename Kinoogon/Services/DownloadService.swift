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
}
