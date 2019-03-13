//
//  InfoModel.swift
//  Kinoogon
//
//  Created by Sultan Karybaev on 2/14/19.
//  Copyright © 2019 Sultan Karybaev. All rights reserved.
//

import Foundation

struct InfoModel: Codable {
    public private(set) var image: String
    public private(set) var title: String?
    public private(set) var description: String?
    public private(set) var id: String?
    public private(set) var count: Int
    
    init(image: String, title: String?, description: String?, id: String?, count: Int) {
        self.image = image
        self.title = title
        self.description = description
        self.id = id
        self.count = count
    }
}
