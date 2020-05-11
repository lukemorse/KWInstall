//
//  MainViewModel.swift
//  KW Install
//
//  Created by Luke Morse on 4/8/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI
import Combine
import Firebase
import CodableFirebase

//testing
let teamDocID = "GadFQUZuxl2gxsh40R9o"

class MainViewModel: ObservableObject {
    // 2
    @Published var team: Team?
    @Published var completedInstallations: [Installation] = []
    @Published var installationDictionary: [Date: [Installation]] = [:]
    
    func fetchTeamData() {
        Firestore.firestore().collection("teams").document(teamDocID).getDocument { document, error in
            if let error = error {
                print(error.localizedDescription)
            }
            if let document = document {
                let teamDoc = try! FirestoreDecoder().decode(Team.self, from: document.data() ?? [:])
                self.team = teamDoc
                self.getInstallations()
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func getInstallations() {
        Firestore.firestore().collection(Constants.kDistrictCollection).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in snapshot!.documents {
                    let district = try! FirestoreDecoder().decode(District.self, from: document.data())
                    if district.team == self.team {
                        for install in district.implementationPlan {
                            if install.status == .complete {
                                self.completedInstallations.append(install)
                            } else {
                                self.addToFutureInstallations(install)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getInstallation(date: Date, index: Int) -> Binding<Installation> {
        return Binding(get: {
            return self.installationDictionary[date]![index]
        }, set: {
            self.installationDictionary[date]![index] = $0
        })
        
    }
    
    fileprivate func addToFutureInstallations(_ install: Installation) {
        let date = removeTimeStamp(fromDate: install.date)
        //add to installation dictionary under appropriate key ...
        if self.installationDictionary[date] == nil {
            self.installationDictionary.updateValue([install], forKey: date)
        } else {
            //            ... or add that key if it doesn't exist
            self.installationDictionary[date]?.append(install)
        }
    }
    
    
}


