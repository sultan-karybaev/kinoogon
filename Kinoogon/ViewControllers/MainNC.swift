//
//  MainNC.swift
//  Kinoogon
//
//  Created by Sultan Karybaev on 1/10/19.
//  Copyright © 2019 Sultan Karybaev. All rights reserved.
//

import UIKit
import Firebase

class MainNC: UINavigationController {

    private var tabbar: UITabBarController!
    
    public var startImageWidth: CGFloat?
    public var startImageTop: CGFloat?
    public var startImageHeight: CGFloat?
    
    public var podcastView: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabbar = self.viewControllers[0] as? UITabBarController
        
//        Storage.storage().reference().child("2018-12-11 16.57.30.jpg").downloadURL { (url, error) in
//            if let error = error {
//                debugPrint("PodcastVC.swift \(error.localizedDescription)")
//            } else {
//
//            }
//        }
        var data: StorageMetadata? = nil
        Storage.storage().reference().child("images/z7_Hvhyqmh8.jpg").getMetadata { (StorageMetadata, Error) in
            if let error = Error {
                debugPrint("PodcastVC.swift \(error.localizedDescription)")
            }
            if let metadata = StorageMetadata {
                print("metadata \(metadata)")
                //metadata.bucket
                //data = metadata
            }
        }
        //guard let metadata = data else { return }
        let f = StorageMetadata(dictionary: [ "name" : "contentDisposition" ])
        Storage.storage().reference().child("2018-12-11 16.57.30.jpg").updateMetadata(f!) { (StorageMetadata, Error) in
            if let error = Error {
                debugPrint("PodcastVC.swift \(error.localizedDescription)")
            }
            if let metadata = StorageMetadata {
                print("metadata \(metadata)")
                //metadata.bucket
                //data = metadata
            }
        }
        
        
        Storage.storage().reference().storage.reference()
        //var bucket = gcs.bucket('my-bucket');
        //var file = bucket.file('my-image.png');
        //var newLocation = 'gs://another-bucket/my-image-new.png';
        //file.move(newLocation, function(err, destinationFile, apiResponse) {
            // `my-bucket` no longer contains:
            // - "my-image.png"
            //
            // `another-bucket` now contains:
            // - "my-image-new.png"
            
            // `destinationFile` is an instance of a File object that refers to your
            // new file.
        //});
    }

    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard let soundcloudVC = tabbar.selectedViewController as? SoundCloudVC else { return }
        soundcloudVC.bottomSafeAreaConstraint.constant -= self.view.frame.height - tabbar.tabBar.frame.origin.y
        tabbar.tabBar.frame.origin.y = self.view.frame.height
    }

}
