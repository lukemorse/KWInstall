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
    @Published var installationDictionary: [Date: [Installation]] = [:]
    
    func updateStatus(date: Date) {
//        let data: [String: Any] = ["implementationPlan" : status.description]
//        if let implementationPlan = installationDictionary[date] {
//            let data = try! FirestoreEncoder().encode(implementationPlan)
            
//            Firestore.firestore().collection(Constants.kDistrictCollection).document("id").getd
            
//            Firestore.firestore().collection(Constants.kDistrictCollection).document("documentPath").setData(data) { error in
//                if let error = error {
//                    print(error.localizedDescription)
//                }
//            }
//        }
        
        
        
    }
}
