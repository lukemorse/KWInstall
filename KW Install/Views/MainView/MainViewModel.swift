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

class MainViewModel: ObservableObject {
    // 2
    @Published var teamData: Team?
    @Published var calendarViewModel: CalendarViewModel
    @Published var completedInstallations: [Installation] = []
    
    init(calendarViewModel: CalendarViewModel) {
        self.calendarViewModel = calendarViewModel
    }
    
    func fetchTeamData() {
        Firestore.firestore().collection("teams").document("2YRtIFLhYdTe7UNCvoVz").getDocument { document, error in
            if let document = document {
                let teamDoc = try! FirestoreDecoder().decode(Team.self, from: document.data() ?? [:])
                self.teamData = teamDoc
                self.getInstallations()
            } else {
                print("Document does not exist")
            }
        }
    }
    
    
    
    private func getInstallations() {
        if let teamData = teamData {
            let docRefs = teamData.installations
            for ref in docRefs {
                ref.getDocument { document, error in
                    if let document = document {
                        let install = try! FirestoreDecoder().decode(Installation.self, from: document.data() ?? [:])
                        if install.completed {
                            self.completedInstallations.append(install)
                        } else {
                            self.addToFutureInstallations(install)
                        }
                        
                    } else {
                        print("Document does not exist")
                    }
                }
            }
        }
    }
    
    fileprivate func addToFutureInstallations(_ install: Installation) {
        self.calendarViewModel.installList.append(install)
        //add to installation dictionary under appropriate key ...
        let dateDesc = timeStampToDateString(install.timeStamp)
        print("date value: " + dateDesc)
        if self.calendarViewModel.installationDictionary[dateDesc] == nil {
            self.calendarViewModel.installationDictionary.updateValue([install], forKey: dateDesc)
        } else {
//            ... or add that key if it doesn't exist
            self.calendarViewModel.installationDictionary[dateDesc]?.append(install)
        }
    }
}


