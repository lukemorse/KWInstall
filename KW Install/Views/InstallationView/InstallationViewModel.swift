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
    
    init(schoolName: String, docID: String) {
        var installation = Installation()
        installation.schoolName = schoolName
        self.installation = installation
        
        fetchInstallData(docID: docID)
    }
    
    private func fetchInstallData(docID: String) {
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
}
