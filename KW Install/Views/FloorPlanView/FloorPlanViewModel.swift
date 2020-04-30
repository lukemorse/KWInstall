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
        
        
        
//        let storage = Storage.storage()
//        let storageRef = storage.reference(forURL: self.storageUrl)
//        storageRef.
        
//        Firestore.firestore().collection(Constants.kFloorPlanCollection).document(storageUrl).getDocument { (document, error) in
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//            if let document = document {
//                if let data = document.data() {
//                    let floorPlanModel = try! FirestoreDecoder().decode([String: FloorPlanModel].self, from: data)
//                    for (_, value) in floorPlanModel {
//                        //download image
//                        self.downloadImage(with: value.imageURL)
////                        let pds = value.po
//                    }
//                    print(floorPlanModel)
//                } else {
//                    print("cant get data")
//                }
//            } else {
//                print("document does not exist")
//            }
//        }
    }
    
//    func downloadImage(urlString: String) {
//        let url = URL(string: urlString)
//        let uiImageView = UIImageView()
//        uiImageView.kf.setImage(with: url)
//        self.floorPlanThumbnails.append(uiImageView)
//
//    }
    
    func downloadImage(with urlString : String){
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
//        let query = Firestore.firestore().collection(Constants.kFloorPlanCollection).whereField("uid", isEqualTo: uid)
//        query.getDocuments { (snapshot, error) in
//            if let error = error {
//                print(error.localizedDescription)
//            }
//            guard let snapshot = snapshot,
//                let data = snapshot.documents.first?.data(),
//                let urlString = data["imageURL"]
//            else {
//                print("could not get document")
//            }
//
//        }
//    }
    
}
