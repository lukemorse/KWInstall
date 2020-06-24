//
//  CalendarViewModel.swift
//  KW Install
//
//  Created by Luke Morse on 4/7/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI
import Combine
import Firebase
import CodableFirebase

class CalendarViewModel: ObservableObject {
    let installationCollection = Firestore.firestore().collection(Constants.kInstallationCollection)
    @Published var installations: [Installation] = []
    
    public func fetchInstallations(for date: Date, isMaster: Bool, teamName: String, completion: @escaping () -> ()) {
        var query = installationCollection.whereField("date", isInDate: date)
        if !isMaster {
            query = query.whereField("teamName", isEqualTo: teamName)
        }
        
        query.getDocuments { (snapshot, error) in
            if let error = error {
                print(error)
                return
            }
            self.installations = []
            for document in snapshot!.documents {
                do {
                    let install = try FirestoreDecoder().decode(Installation.self, from: document.data())
                    //filter out complete installs
                    if install.status != .complete {
                        self.installations.append(install)
                    }
                    
                } catch {
                    print(error)
                }
            }
            completion()
        }
    }
}
