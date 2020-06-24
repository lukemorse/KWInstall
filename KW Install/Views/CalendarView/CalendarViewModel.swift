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
    let isMaster: Bool
    let teamName: String
    let installationCollection = Firestore.firestore().collection(Constants.kInstallationCollection)
    @Published var isLoading = false
    @Published var installations: [Installation] = []
    @ObservedObject var rkManager = RKManager(calendar: Calendar.current, minimumDate: Date().addingTimeInterval(-60*60*24*7), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0)
    
    private var disposables = Set<AnyCancellable>()
    
    init(isMaster: Bool, teamName: String) {
        self.teamName = teamName
        self.isMaster = isMaster
        self.rkManager.$selectedDate
            .sink { (date) in
                if let date = date {
                    self.onDateTapped(date: date)
                }
        }
    .store(in: &disposables)
    }
    
    func onDateTapped(date: Date) {
        isLoading = true
        fetchInstallations(for: date.formatForDB()) {
            self.isLoading = false
        }
    }
    
    public func fetchInstallations(for date: Date, completion: @escaping () -> ()) {
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
