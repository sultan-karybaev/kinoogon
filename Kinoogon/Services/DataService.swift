//
//  DataService.swift
//  Kinoogon
//
//  Created by Sultan Karybaev on 2/14/19.
//  Copyright © 2019 Sultan Karybaev. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Firestore.firestore()

final class DataService {
    
    public static let instance = DataService()
    
    private let podcast = DB_BASE.collection("podcast")
    
    public func asd() {
        podcast.getDocuments { (QuerySnapshot, Error) in
            if let error = Error {
                debugPrint("DataService.swift getAllFeedMessages() \(error.localizedDescription)")
                //handler(false, false)
                return
            }
            if let snapshot = QuerySnapshot {
                print("snapshot.documents \(snapshot.documents[0].data())")
            }
        }
    }
}
