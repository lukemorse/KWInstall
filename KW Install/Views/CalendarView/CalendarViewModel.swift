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
    
//    func updateStatus(date: Date) {
////        let data: [String: Any] = ["implementationPlan" : status.description]
////        if let implementationPlan = installationDictionary[date] {
////            let data = try! FirestoreEncoder().encode(implementationPlan)
//
////            Firestore.firestore().collection(Constants.kDistrictCollection).document("id").getd
//
////            Firestore.firestore().collection(Constants.kDistrictCollection).document("documentPath").setData(data) { error in
////                if let error = error {
////                    print(error.localizedDescription)
////                }
////            }
////        }
//    }
    
    public func fetchInstallations(for date: Date, isMaster: Bool, teamName: String) {
        let query = isMaster ? installationCollection.whereField("date", isInDate: date) :
            installationCollection.whereField("date", isInDate: date).whereField("teamName", isEqualTo: teamName)
        
        query.getDocuments { (snapshot, error) in
            if let error = error {
                print(error)
                return
            }
            for document in snapshot!.documents {
                do {
                    let install = try FirestoreDecoder().decode(Installation.self, from: document.data())
                    self.installations.append(install)
                } catch {
                    print(error)
                }
            }
            return
        }
    }
}
