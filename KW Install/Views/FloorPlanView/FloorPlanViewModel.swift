//
//  FloorPlanViewModel.swift
//  KW Install
//
//  Created by Luke Morse on 4/28/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI
import Combine
import Firebase
import CodableFirebase
import Kingfisher

class FloorPlanViewModel: ObservableObject {
    
    let installation: Installation
    @Published var floorPlanThumbnails: [UIImage] = []
    @Published var pods: [[Pod]] = [[]]
    
    init(installation: Installation) {
        self.installation = installation
    }
    
    func getFloorPlans() {
        for url in installation.floorPlanUrls {
            downloadImage(with: url)
            print(pods.count)
            if pods[0].isEmpty {
                self.pods[0] = self.installation.pods[url] ?? []
            } else {
                self.pods.append(self.installation.pods[url] ?? [])
            }
        }
    }
    
    func downloadImage(with urlString : String) {
        guard let url = URL.init(string: urlString) else {
            return
        }
        let resource = ImageResource(downloadURL: url)
        
        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let value):
                self.floorPlanThumbnails.append(value.image)
                print("Image: \(value.image). Got from: \(value.cacheType)")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func uploadPodImage(image: UIImage, completion: @escaping (_ url: String?) -> Void) {

        let storageRef = Storage.storage().reference().child(Constants.kPodImageFolder).child("newPodImage")
        
        if let uploadData = image.jpegData(compressionQuality: 0.5) {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if let error = error {
                    print(error.localizedDescription)
                    completion(nil)
                } else {
                    storageRef.downloadURL(completion: { (url, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        completion(url?.absoluteString)
                    })
                }
            }
        }
    }
    
}
