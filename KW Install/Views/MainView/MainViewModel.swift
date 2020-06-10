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
    @Published var installationDictionary: [Date: [Installation]] = [:]
    var teamDocID = ""
    var isMasterAccount = false
    
    private func addToInstallationDict(_ install: Installation) {
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
        if isMasterAccount {
            self.fetchInstallations()
            return
        }
        Firestore.firestore().collection("teams").document(teamDocID).getDocument { document, error in
            if let error = error {
                print(error.localizedDescription)
            }
            if let document = document {
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
                    do {
                        let district = try FirestoreDecoder().decode(District.self, from: document.data())
                        //only continue to add if ready to install
                        if district.readyToInstall {
                            for install in district.implementationPlan {
                                if install.team.name == self.team?.name || self.isMasterAccount {
                                    self.addToInstallationDict(install)
                                }
                            }
                        }
                    } catch let error {
                        print("Error fetching installations:  \(error)")
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
    
    public func getInstallation(installation: Installation) -> Binding<Installation>? {
        let keys = Array(installationDictionary.keys)
//        let array = Array(installationDictionary.values)
        for key in keys {
            for (index, install) in installationDictionary[key]!.enumerated() {
                if install.districtName == installation.districtName && install.schoolName == installation.schoolName {
                    return Binding(get: {
                        return self.installationDictionary[key]![index]
                    }, set: {
                        self.installationDictionary[key]![index] = $0
                    })
                }
            }
        }
        return nil
    }
    
    public func updatePods(for installation: Installation, url: String, pods: [Pod]) {
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
                    district.implementationPlan[index].pods = [url: pods]
                    
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
    
    public func updateInstallationStatus(for installation: Installation) {
        let docRef = Firestore.firestore().collection(Constants.kDistrictCollection).document(installation.districtName)
        
        docRef.getDocument { (snapshot, error) in
            if let error = error {
                print(error)
            }
            if let document = snapshot, document.exists {
                do {
                    var district = try FirestoreDecoder().decode(District.self, from: document.data() ?? [:])
                    
                    //find index of installation
                    var index: Int?
                    for (testIndex, testInstall) in district.implementationPlan.enumerated() {
                        if testInstall.schoolName == installation.schoolName {
                            index = testIndex
                        }
                    }
                    //update implementation plan
                    if let index = index {
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
                    }
                    else {
                        print("Error: could not find ")
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}


