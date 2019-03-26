//
//  DataStorage.swift
//  Kinoogon
//
//  Created by Sultan Karybaev on 2/14/19.
//  Copyright © 2019 Sultan Karybaev. All rights reserved.
//

import Foundation

class DataStorage {
    public var HOSTS_IMAGES_DICTIONARY: [String: [String: Data]] = [:]
    //public var HOSTS_IMAGES_DICTIONARY: [String: [String: Data]] = [:]
    
    public static let instance = DataStorage()
}
