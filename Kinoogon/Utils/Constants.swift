//
//  Constants.swift
//  Kinoogon
//
//  Created by Sultan Karybaev on 11/29/18.
//  Copyright © 2018 Sultan Karybaev. All rights reserved.
//

import Foundation

let YOUTUBE_KEY = "AIzaSyAE974kJYy9OkabEAwUifDDw3v4-hDQ1XU"

func getYoutubeAPI(videoID key: String) -> String {
    return "https://www.googleapis.com/youtube/v3/videos?id=\(key)&key=\(YOUTUBE_KEY)&part=snippet,contentDetails,statistics"
}
