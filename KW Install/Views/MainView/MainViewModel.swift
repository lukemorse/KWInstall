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
let teamDocID = "HtCkclIRoAtNXUkbxl9y"

class MainViewModel: ObservableObject {
    // 2
    @Published var team: Team?
    @Published var calendarViewModel: CalendarViewModel
    @Published var completedInstallations: [Installation] = []
    
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
    
    func getInstallations() {
        Firestore.firestore().collection(Constants.kDistrictCollection).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in snapshot!.documents {
                    let district = try! FirestoreDecoder().decode(District.self, from: document.data())
                    for install in district.implementationPlan {
                        if install.team.name
                        == self.team?.name {
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
    
    //
    //
    //    private func getInstallations() {
    //        if let team = team {
    //            let installs = teamData.installations
    //            for ref in docRefs {
    //                ref.getDocument { document, error in
    //                    if let document = document {
    //                        let install = try! FirestoreDecoder().decode(Installation.self, from: document.data() ?? [:])
    //                        if install.completed {
    //                            self.completedInstallations.append(install)
    //                        } else {
    //                            self.addToFutureInstallations(install)
    //                        }
    //
    //                    } else {
    //                        print("Document does not exist")
    //                    }
    //                }
    //            }
    //        }
    //    }
    
    fileprivate func addToFutureInstallations(_ install: Installation) {
        self.calendarViewModel.installList.append(install)
        //add to installation dictionary under appropriate key ...
        let timeStamp = Timestamp(date: install.date)
        let dateDesc = timeStampToDateString(timeStamp)
//        let dateDesc = removeTimeStamp(fromDate: install.date).de
        
        print("date value: " + dateDesc)
        if self.calendarViewModel.installationDictionary[dateDesc] == nil {
            self.calendarViewModel.installationDictionary.updateValue([install], forKey: dateDesc)
        } else {
            //            ... or add that key if it doesn't exist
            self.calendarViewModel.installationDictionary[dateDesc]?.append(install)
        }
    }
}

public func removeTimeStamp(fromDate: Date) -> Date {
    guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: fromDate)) else {
        fatalError("Failed to strip time from Date object")
    }
    return date
}
