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
    
    init(installation: Installation) {
        self.installation = installation
    }
    
    func setStatus(status: InstallationStatus) {
        self.installation.status = status
        Firestore.firestore().collection(Constants.kInstallationCollection).document(installation.installationID).setData(["status": status], merge: true)
    }
}
