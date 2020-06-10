//
//  MainViewModel.swift
//  KW Install
//
//  Created by Luke Morse on 4/8/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI
import Combine
import FirebaseFirestore
import CodableFirebase

class MainViewModel: ObservableObject {
    
    @Published var team: Team?
    var teamDocID = ""
    var isMasterAccount = false
    
    public func fetchTeamData() {
        if isMasterAccount {
            self.fetchInstallationMasterList()
            return
        }
        Firestore.firestore().collection("teams").document(teamDocID).getDocument { document, error in
            if let error = error {
                print(error.localizedDescription)
            }
            if let document = document {
                let teamDoc = try! FirestoreDecoder().decode(Team.self, from: document.data() ?? [:])
                self.team = teamDoc
            } else {
                print("Document does not exist")
            }
        }
    }
    
    private func fetchInstallationMasterList() {
        
    }
    
//    public func fetchInstallations() {
//        Firestore.firestore().collection(Constants.kDistrictCollection).getDocuments { (snapshot, error) in
//            if let error = error {
//                print("Error getting documents: \(error)")
//            } else {
//                //get district
//                for document in snapshot!.documents {
//                    do {
//                        let district = try FirestoreDecoder().decode(District.self, from: document.data())
//                        //only continue to add if ready to install
//                        if district.readyToInstall {
//                            for install in district.implementationPlan {
//                                if install.team.name == self.team?.name || self.isMasterAccount {
//                                    self.addToInstallationDict(install)
//                                }
//                            }
//                        }
//                    } catch let error {
//                        print("Error fetching installations:  \(error)")
//                    }
//
//                }
//            }
//        }
//    }
    
//    private func addToInstallationDict(_ install: Installation) {
//        let date = removeTimeStamp(fromDate: install.date)
//        //add to installation dictionary under appropriate key ...
//        if self.installationDictionary[date] == nil {
    //            self.installationDictionary.updateValue([install], forKey: date)
    //        } else {
    //            //            ... or add that key if it doesn't exist
    //            self.installationDictionary[date]?.append(install)
    //        }
    //    }
    
    public func fetchInstallation(docPath: String, completion: @escaping (Installation) -> Void) {
        Firestore.firestore().collection(Constants.kInstallationCollection).document(docPath).getDocument { (document, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                do {
                    let installation = try FirebaseDecoder().decode(Installation.self, from: document?.data() ?? Installation())
                    completion(installation)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    public func uploadInstallation(docPath: String, installation: Installation) {
        let docRef = Firestore.firestore().collection(Constants.kInstallationCollection).document(docPath)
        do {
            let docData = try FirestoreEncoder().encode(installation)
            docRef.setData(docData)
        } catch {
            print(error)
        }
    }
    
    public func updatePods(for url: String, pods: [Pod]) {
        let docRef = Firestore.firestore().collection(Constants.kPodCollection).document(url)
        do {
            let docData = try FirestoreEncoder().encode(pods)
            docRef.setData(docData)
        } catch {
            print(error)
        }
    }
    
    public func updateInstallationStatus(for docPath: String, status: InstallationStatus) {
        let docRef = Firestore.firestore().collection(Constants.kInstallationCollection).document(docPath)
        docRef.setData(["status": status], merge: true)
    }
}


