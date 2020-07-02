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
        Firestore.firestore().collection(Constants.kInstallationCollection).document(installation.installationID).setData(["status": status.rawValue], merge: true)
        setDistrictStatus(installStatus: status)
        
    }
    
    func setDistrictStatus(installStatus: InstallationStatus) {
        Firestore.firestore().collection(Constants.kDistrictCollection).document(installation.districtID).getDocument { (snapshot, error) in
            if let error = error {
                print(error)
            } else {
                let data = snapshot!.data()
                if let districtStatus = data?["status"] as? Int {
                    if installStatus == .complete && districtStatus == DistrictStatus.pending.rawValue {
                        self.tryMarkDistrictComplete()
                        //if district has been marked complete and install is not complete, adjust district status
                    } else if installStatus != .complete && districtStatus == DistrictStatus.complete.rawValue {
                        self.markDistrictPending()
                    }
                }
            }
        }
    }
    
    func markDistrictPending() {
        Firestore.firestore().collection(Constants.kDistrictCollection).document(self.installation.districtID).setData(["status": DistrictStatus.pending.rawValue], merge: true)
    }
    
    func tryMarkDistrictComplete() {
        //check if rest of installations in district are complete
        Firestore.firestore().collection(Constants.kInstallationCollection).whereField("districtID", isEqualTo: self.installation.districtID).getDocuments { (snapshot, error) in
            if let error = error {
                print(error)
            } else {
                for document in snapshot!.documents {
                    if let status = document.data()["status"] as? Int {
                        if status != InstallationStatus.complete.rawValue {
                            return
                        }
                    } else {return}
                }
                //all installations are complete
                Firestore.firestore().collection(Constants.kDistrictCollection).document(self.installation.districtID).setData(["status": DistrictStatus.complete.rawValue], merge: true)
            }
        }
    }
}
