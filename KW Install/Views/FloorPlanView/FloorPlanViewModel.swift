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
    let podDocRef: DocumentReference
    
    @Published var floorPlanThumbnails: [UIImage] = []
    @Published var pods: [Pod] = []
    
    init(url: URL, installID: String, floorNumString: String) {
        self.url = url
        self.podDocRef = Firestore.firestore().collection(Constants.kInstallationCollection).document(installID).collection("pods").document(floorNumString)
    }
    
//    func setPods(completion: @escaping (Bool) -> ()) {
//        do {
//            let data = try FirestoreEncoder().encode(["pods" : self.pods])
//            self.podDocRef.setData(data) { (error) in
//                if let error = error {
//                    print(error)
//                    completion(false)
//                } else {
//                    completion(true)
//                }
//            }
//        } catch {
//            print(error)
//        }
//    }
    
    func fetchPods() {
        self.podDocRef.getDocument { document, error in
            if let error = error {
                print(error.localizedDescription)
            }
            if let document = document {
                do {
                    let podDict = try FirestoreDecoder().decode([String:Pod].self, from: document.data() ?? [:])
                    self.pods = Array(podDict.values)
                } catch {
                    print(error)
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func uploadPodImage(image: UIImage, podIndex: Int, completion: @escaping (Bool) -> Void) {
        let pod = pods[podIndex]
        let storageRef = Storage.storage().reference().child(Constants.kPodImageFolder).child(self.url.absoluteString).child(pod.podType.description).child(UUID().uuidString)
        
        if let uploadData = image.jpegData(compressionQuality: 0.25) {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if let error = error {
                    print(error.localizedDescription)
                    completion(false)
                } else {
                    storageRef.downloadURL(completion: { (url, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }
//                        completion(url?.absoluteString)
                        self.pods[podIndex].imageUrl = url?.absoluteString
                        self.setPod(pod: self.pods[podIndex]) { (success) in
                            completion(success)
                        }
                    })
                }
            }
        }   
    }
    
    private func setPod(pod: Pod, completion: @escaping (Bool) -> ()) {
//            let data = try FirestoreEncoder().encode(pod)
        self.podDocRef.updateData(["\(pod.uid).imageUrl" : pod.imageUrl as Any]) { (error) in
                if let error = error {
                    print(error)
                    completion(false)
                    return
                }
                completion(true)
            }
        
    }
}
