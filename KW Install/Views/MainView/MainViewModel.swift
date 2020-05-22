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
let teamDocID = "8xFzS68oeyo34DSDvJHj"

class MainViewModel: ObservableObject {
    
    @Published var team: Team?
    @Published var completedInstallations: [Installation] = []
    @Published var installationDictionary: [Date: [Installation]] = [:]
    
    private func addToFutureInstallations(_ install: Installation) {
        let date = removeTimeStamp(fromDate: install.date)
        //add to installation dictionary under appropriate key ...
        if self.installationDictionary[date] == nil {
            self.installationDictionary.updateValue([install], forKey: date)
        } else {
            //            ... or add that key if it doesn't exist
            self.installationDictionary[date]?.append(install)
        }
    }
    
    public func fetchTeamData() {
        Firestore.firestore().collection("teams").document(teamDocID).getDocument { document, error in
            if let error = error {
                print(error.localizedDescription)
            }
            if let document = document {
                print("here:")
                print(document.data() ?? [:])
                let teamDoc = try! FirestoreDecoder().decode(Team.self, from: document.data() ?? [:])
                self.team = teamDoc
                self.fetchInstallations()
            } else {
                print("Document does not exist")
            }
        }
    }
    
    public func fetchInstallations() {
        Firestore.firestore().collection(Constants.kDistrictCollection).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                //get district
                for document in snapshot!.documents {
                    let district = try! FirestoreDecoder().decode(District.self, from: document.data())
                    //only continue to add if ready to install
                    if district.readyToInstall {
                        for install in district.implementationPlan {
                            if install.team.name == self.team?.name {
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
    }
    
    public func getInstallation(date: Date, index: Int) -> Binding<Installation> {
        return Binding(get: {
            return self.installationDictionary[date]![index]
        }, set: {
            self.installationDictionary[date]![index] = $0
        })
    }
    
    public func updateInstallationStatus(for installation: Installation) {
        let docRef = Firestore.firestore().collection(Constants.kDistrictCollection).document(installation.districtName)
        
        docRef.getDocument { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let document = snapshot, document.exists {
                do {
                    var district = try FirestoreDecoder().decode(District.self, from: document.data() ?? [:])
                    
                    //find index of installation
                    var index = 0
                    for (testIndex, testInstall) in district.implementationPlan.enumerated() {
                        if testInstall.schoolName == installation.schoolName {
                            index = testIndex
                        }
                    }
                    //update implementation plan
                    district.implementationPlan[index].status = installation.status
                    
                    //send district file to database
                    let districtData = try! FirestoreEncoder().encode(district)
                    docRef.setData(districtData) { error in
                        if let error = error {
                            print("Error writing document: \(error)")
                            
                        } else {
                            print("Document successfully written!")
                        }
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}


