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
    public private(set) var YOUTUBE_ARRAY: [YouTubeVideo] = [YouTubeVideo]()
    
    public static let instance = DataService()
    
    private let PODCASTS_REF = DB_BASE.collection("podcast")
    private let HOSTS_REF = DB_BASE.collection("host")
    private let PICTURES_REF = DB_BASE.collection("picture")
    private let YOUTUBE_REF = DB_BASE.collection("youtubeVideo")
    
    public func getAllHosts(handler: @escaping (Bool) -> ()) {
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
    
    public func getYouTubeVideo(handler: @escaping (Bool) -> ()) {
        YOUTUBE_REF.getDocuments { (QuerySnapshot, Error) in
            if let error = Error {
                debugPrint("DataService.swift getYouTubeVideo() \(error.localizedDescription)")
                handler(false)
                return
            }
            if let snapshot = QuerySnapshot {
                self.YOUTUBE_ARRAY = [YouTubeVideo]()
                for document in snapshot.documents {
                    do {
                        let youtubeVideo = try FirestoreDecoder().decode(YouTubeVideo.self, from: document.data())
                        self.YOUTUBE_ARRAY.append(youtubeVideo)
                    } catch let error {
                        debugPrint("DataService.swift getAllFeedMessages() Document is not appropriate \(error.localizedDescription)")
                    }
                }
                handler(true)
            } else {
                handler(false)
            }
        }
    }
    
//    public func addYoutube() {
//        let titleArray: [String] = ["ЛЕДЕНЯЩИЕ ДУШУ ПРИКЛЮЧЕНИЯ САБРИНЫ [РЕЙТИНГ СЕРИАЛОВ]", "КАК ИСЧЕЗ РУПЕРТ ГРИНТ [ПОЛНАЯ ХРОНОЛОГИЯ]", "ВСЕЛЕННАЯ ГАРРИ ПОТТЕРА: ОТ ХУДШЕГО ФИЛЬМА К ЛУЧШЕМУ", "ПАМЯТИ СТЭНА ЛИ. 7 ЛУЧШИХ КАМЕО И 7 ЛУЧШИХ ГЕРОЕВ", "СОРВИГОЛОВА 3 СЕЗОН [РЕЙТИНГ СЕРИАЛОВ]", "ЧЕГО БОЯТСЯ В ГОЛЛИВУДЕ? 17 САМЫХ СТРАННЫХ ФОБИЙ АКТЕРОВ И РЕЖИССЕРОВ", "12 ЖУТКИХ ФАНАТСКИХ ТЕОРИЙ О КУЛЬТОВЫХ ФИЛЬМАХ", "КАКИМ БУДЕТ СЕРИАЛ ВЕДЬМАК [ПО СЕКРЕТУ]", "ТОП-10 | ЛУЧШИЕ РОЛИ МУЗЫКАНТОВ В КИНО"]
//        let imageArray: [String] = ["https://i.ytimg.com/vi/GZQIntBz2eI/hqdefault.jpg", "https://i.ytimg.com/vi/0cljQstOKR4/hqdefault.jpg", "https://i.ytimg.com/vi/pMonTywrze8/hqdefault.jpg", "https://i.ytimg.com/vi/PzW30e8MDEA/hqdefault.jpg", "https://i.ytimg.com/vi/SBGbWEPY4tY/hqdefault.jpg", "https://i.ytimg.com/vi/nmXJOLXcIjM/hqdefault.jpg", "https://i.ytimg.com/vi/qz_l1eBa_EM/hqdefault.jpg", "https://i.ytimg.com/vi/k97xoEZnq7Y/hqdefault.jpg", "https://i.ytimg.com/vi/n3JfEjz1UZs/hqdefault.jpg"]
//        let idArray: [String] = ["GZQIntBz2eI", "0cljQstOKR4", "pMonTywrze8", "PzW30e8MDEA", "SBGbWEPY4tY", "nmXJOLXcIjM", "qz_l1eBa_EM", "k97xoEZnq7Y", "n3JfEjz1UZs"]
//        for index in 1...titleArray.count {
//            YOUTUBE_REF.addDocument(data: [ "title" : titleArray[index - 1], "image" : imageArray[index - 1], "id" : idArray[index - 1] ])
//        }
//
//    }
    
    
    
}
