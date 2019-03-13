//
//  DataService.swift
//  Kinoogon
//
//  Created by Sultan Karybaev on 2/14/19.
//  Copyright © 2019 Sultan Karybaev. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase

let DB_BASE = Firestore.firestore()


final class DataService {
    
    public private(set) var HOSTS_ARRAY: [InfoModel] = [InfoModel]()
    public private(set) var HOSTS_PICTURES_DICTIONARY: [String: [InfoModel]] = [:]
    
    public static let instance = DataService()
    
    private let PODCASTS_REF = DB_BASE.collection("podcast")
    private let HOSTS_REF = DB_BASE.collection("host")
    private let PICTURES_REF = DB_BASE.collection("picture")
    
    public func getAllHosts(handler: @escaping (Bool) -> ()) {
        print("getAllHosts")
        HOSTS_REF.getDocuments { (QuerySnapshot, Error) in
            if let error = Error {
                debugPrint("DataService.swift getAllHosts() \(error.localizedDescription)")
                handler(false)
                return
            }
            if let snapshot = QuerySnapshot {
                self.HOSTS_ARRAY = [InfoModel]()
                for document in snapshot.documents {
                    do {
                        let host = try FirestoreDecoder().decode(InfoModel.self, from: document.data())
                        self.HOSTS_ARRAY.append(host)
                    } catch let error {
                        debugPrint("DataService.swift getAllFeedMessages() Document is not appropriate \(error.localizedDescription)")
                    }
                }
                self.HOSTS_ARRAY = self.HOSTS_ARRAY.sorted(by: { (firstModel, secondModel) -> Bool in
                    return firstModel.count < secondModel.count
                })
                handler(true)
            } else {
                handler(false)
            }
        }
    }
    
    public func getHostsPictures(hostID: String, handler: @escaping (Bool) -> ()) {
        PICTURES_REF.whereField("id", isEqualTo: hostID).getDocuments { (QuerySnapshot, Error) in
            if let error = Error {
                debugPrint("DataService.swift getHostsPictures() \(error.localizedDescription)")
                handler(false)
                return
            }
            if let snapshot = QuerySnapshot {
                var infoModelArray = [InfoModel]()
                for document in snapshot.documents {
                    do {
                        let picture = try FirestoreDecoder().decode(InfoModel.self, from: document.data())
                        infoModelArray.append(picture)
                    } catch let error {
                        debugPrint("DataService.swift getAllFeedMessages() Document is not appropriate \(error.localizedDescription)")
                    }
                }
                infoModelArray = infoModelArray.sorted(by: { (firstModel, secondModel) -> Bool in
                    return firstModel.count < secondModel.count
                })
                self.HOSTS_PICTURES_DICTIONARY[hostID] = infoModelArray
                handler(true)
            } else {
                handler(false)
            }
        }
    }
    
    
}
