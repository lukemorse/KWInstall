//
//  FloorPlanViewModel.swift
//  KW Install
//
//  Created by Luke Morse on 4/28/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI
import Combine
import FirebaseFirestore
import CodableFirebase
import FirebaseStorage

class FloorPlanViewModel: ObservableObject {
    
    let url: URL
    @Published var floorPlanThumbnails: [UIImage] = []
    @Published var pods: [Pod] = []
    
    init(url: URL) {
        self.url = url
    }
    
    func setPods(docID: String) {
        do {
            let data = try FirestoreEncoder().encode(self.pods)
            Firestore.firestore().collection(Constants.kPodCollection).document(docID).setData(data)
        } catch {
            print(error)
        }
    }
    
    func fetchPods(docID: String) {
        Firestore.firestore().collection(Constants.kPodCollection).document(docID).getDocument { document, error in
            if let error = error {
                print(error.localizedDescription)
            }
            if let document = document {
                do {
                    let pods = try FirestoreDecoder().decode([Pod].self, from: document.data() ?? [:])
                    self.pods = pods
                } catch {
                    print(error)
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
//    func getFloorPlans() {
//            for (index, url) in installation.floorPlanUrls.enumerated() {
//                downloadImage(with: url)
////                if index < pods.count {
////                    if pods[index].isEmpty {
////                        self.pods[index] = installation.pods[url] ?? []
////                    } else {
////                        self.pods.append(installation.pods[url] ?? [])
////                    }
////                }
////                else {
////                    self.pods.append(installation.pods[url] ?? [])
////                }
//        }
//    }
//
//    func downloadImage(with urlString : String) {
//        guard let url = URL.init(string: urlString) else {
//            return
//        }
//        let resource = ImageResource(downloadURL: url)
//
//        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
//            switch result {
//            case .success(let value):
//                self.floorPlanThumbnails.append(value.image)
//            case .failure(let error):
//                print("Error: \(error)")
//            }
//        }
//    }
    
    func uploadPodImage(image: UIImage, podType: String, completion: @escaping (_ url: String?) -> Void) {
        
        let storageRef = Storage.storage().reference().child(Constants.kPodImageFolder).child(self.url.absoluteString).child(podType).child(UUID().uuidString)
        
        if let uploadData = image.jpegData(compressionQuality: 0.25) {
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
    
    func updatePods(url: String) {
        
    }
    
}
