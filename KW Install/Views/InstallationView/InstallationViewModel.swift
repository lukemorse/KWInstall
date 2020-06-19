//
//  InstallationViewModel.swift
//  KW Install
//
//  Created by Luke Morse on 6/10/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CodableFirebase

class InstallationViewModel: ObservableObject {
    @Published var installation: Installation
    
    init(schoolName: String, districtID: String, docID: String) {
        var installation = Installation(districtID: districtID)
        installation.schoolName = schoolName
        self.installation = installation
        
        fetchInstallData(docID: docID)
    }
    
    func fetchInstallData(docID: String) {
        Firestore.firestore().collection(Constants.kInstallationCollection).document(docID).getDocument { document, error in
            if let error = error {
                print(error.localizedDescription)
            }
            if let document = document {
                do {
                    let installation = try FirestoreDecoder().decode(Installation.self, from: document.data() ?? [:])
                    self.installation = installation
                } catch {
                    print(error)
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    
    
//    func getFloorPlans() {
//                for (index, url) in installation.floorPlanUrls.enumerated() {
//                    downloadImage(with: url)
//    //                if index < pods.count {
//    //                    if pods[index].isEmpty {
//    //                        self.pods[index] = installation.pods[url] ?? []
//    //                    } else {
//    //                        self.pods.append(installation.pods[url] ?? [])
//    //                    }
//    //                }
//    //                else {
//    //                    self.pods.append(installation.pods[url] ?? [])
//    //                }
//            }
//        }
//
//        func downloadImage(with urlString : String) {
//            guard let url = URL.init(string: urlString) else {
//                return
//            }
//            let resource = ImageResource(downloadURL: url)
//
//            KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
//                switch result {
//                case .success(let value):
//                    self.floorPlanThumbnails.append(value.image)
//                case .failure(let error):
//                    print("Error: \(error)")
//                }
//            }
//        }
}
