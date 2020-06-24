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
    @Published var completedInstalls: [Installation] = []
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
    
    public func fetchCompletedInstallations(completion: @escaping () -> ()) {
        let query = isMasterAccount ? installationCollection.whereField("status", isEqualTo: InstallationStatus.complete.rawValue) : installationCollection.whereField("teamName", isEqualTo: team?.name ?? "").whereField("status", isEqualTo: InstallationStatus.complete.rawValue)
        
        query.getDocuments { (snapshot, error) in
            if let error = error {
                print(error)
                return
            }
            self.completedInstalls = []
            for document in snapshot!.documents {
                do {
                    let install = try FirestoreDecoder().decode(Installation.self, from: document.data())
                    self.completedInstalls.append(install)
                } catch {
                    print(error)
                }
            }
            completion()
        }
    }
}


