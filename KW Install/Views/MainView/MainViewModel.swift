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
    let installationCollection = Firestore.firestore().collection(Constants.kInstallationCollection)
    
    public func fetchTeamData() {
        if isMasterAccount {return}
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
    
    public func fetchInstallations(for date: Date, completion: @escaping ([Installation]) -> Void) {
        let query = isMasterAccount ? installationCollection.whereField("date", isEqualTo: date.description) : installationCollection.whereField("date", isEqualTo: date.description).whereField("teamName", isEqualTo: team?.name ?? "")
        
        query.getDocuments { (snapshot, error) in
            if let error = error {
                print(error)
                return
            }
            var result: [Installation] = []
            for document in snapshot!.documents {
                do {
                    let install = try FirestoreDecoder().decode(Installation.self, from: document.data())
                    result.append(install)
                } catch {
                    print(error)
                }
            }
            completion(result)
            return
        }
    }
    
    public func fetchCompletedInstallations(completion: @escaping ([Installation]) -> Void) {
        let query = isMasterAccount ? installationCollection.whereField("status", isEqualTo: InstallationStatus.complete) : installationCollection.whereField("teamName", isEqualTo: team?.name ?? "").whereField("status", isEqualTo: InstallationStatus.complete)
        
        query.getDocuments { (snapshot, error) in
            if let error = error {
                print(error)
                return
            }
            var result: [Installation] = []
            for document in snapshot!.documents {
                do {
                    let install = try FirestoreDecoder().decode(Installation.self, from: document.data())
                    result.append(install)
                } catch {
                    print(error)
                }
            }
            completion(result)
            return
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
    
//    public func getInstallationArray(date: Date) -> [String] {
//        var result: [String] = []
//        if let team = team {
//            if let arr = team.installations[date] {
//                result = Array(arr.values)
//            }
//        }
//        return result
//    }
//
//    public func getCompletedInstallations() -> [String] {
//        var result: [String] = []
//        if let team = team {
//            for (schoolName, _) in team.completedInstallations {
//                result.append(schoolName)
//            }
//        }
//        return result
//    }
}


