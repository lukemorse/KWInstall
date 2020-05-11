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
    @Published var calendarViewModel: CalendarViewModel
    @Published var completedInstallations: [Installation] = []
    @Published var districts: [District] = []
    
    init(calendarViewModel: CalendarViewModel) {
        self.calendarViewModel = calendarViewModel
    }
    
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
    
    func updateStatus(path: String, status: InstallationStatus) {
        var implementationPlan = districts[0].implementationPlan
        implementationPlan[0].status = status
        let data = try! FirestoreEncoder().encode(implementationPlan)
        
        Firestore.firestore().collection(Constants.kDistrictCollection).document(path).setData(data, merge: true) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func getInstallations() {
        Firestore.firestore().collection(Constants.kDistrictCollection).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in snapshot!.documents {
                    var district = try! FirestoreDecoder().decode(District.self, from: document.data())
                    if district.team == self.team {
                        self.districts.append(district)
                        for (index, install) in district.implementationPlan.enumerated() {
                            if install.status == .complete {
                                self.completedInstallations.append(install)
                            } else {
                                self.addToFutureInstallations(
                                    Binding(
                                        get: {return install},
                                        set: {district.implementationPlan[index] = $0}
                                    ))
                            }
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func addToFutureInstallations(_ install: Binding<Installation>) {
        let date = removeTimeStamp(fromDate: install.wrappedValue.date)
        //add to installation dictionary under appropriate key ...
        if self.calendarViewModel.installationDictionary[date] == nil {
            self.calendarViewModel.installationDictionary.updateValue([install], forKey: date)
        } else {
            //            ... or add that key if it doesn't exist
            self.calendarViewModel.installationDictionary[date]?.append(install)
        }
    }
    
    
}


