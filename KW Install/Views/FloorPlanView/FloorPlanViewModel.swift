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
    
    func setPods() {
        do {
            let data = try FirestoreEncoder().encode(self.pods)
            self.podDocRef.setData(data)
        } catch {
            print(error)
        }
    }
    
    func fetchPods() {
        self.podDocRef.getDocument { document, error in
            if let error = error {
                print(error.localizedDescription)
            }
            if let document = document {
                do {
                    let pods = try FirestoreDecoder().decode([String:[Pod]].self, from: document.data() ?? [:])
                    self.pods = pods["pods"] ?? []
                } catch {
                    print(error)
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
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
}
