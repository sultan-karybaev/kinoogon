//
//  YouTubeVideo.swift
//  Kinoogon
//
//  Created by Sultan Karybaev on 11/29/18.
//  Copyright © 2018 Sultan Karybaev. All rights reserved.
//

import UIKit

struct YouTubeVideo: Codable {
    public private(set) var image: String
    public private(set) var title: String
    public private(set) var id: String
    
    init(image: String, title: String, id: String) {
        self.image = image
        self.title = title
        self.id = id
    }
}
