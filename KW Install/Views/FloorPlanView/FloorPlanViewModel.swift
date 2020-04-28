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
    
    let docID: String
    @Published var floorPlanThumbnails: [UIImage] = []
    
    init(docID: String) {
        self.docID = docID
    }
    
    @Published var completedInstallations: [Installation] = []
    
    func getFloorPlans() {
        print("get floor plans")
        Firestore.firestore().collection(Constants.kFloorPlanCollection).document(docID).getDocument { (document, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let document = document {
                if let data = document.data() {
                    let floorPlanModel = try! FirestoreDecoder().decode([String: FloorPlanModel].self, from: data)
                    for (_, value) in floorPlanModel {
                        //download image
                        self.downloadImage(with: value.imageURL)
                    }
                    print(floorPlanModel)
                } else {
                    print("cant get data")
                }
            } else {
                print("document does not exist")
            }
        }   
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
