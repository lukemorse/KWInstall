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

class CalendarViewModel: ObservableObject, Identifiable {
  // 2
    @Published var installList: [Installation] = []
    
    private let dataFetcher: DataFetchable
    private var disposables = Set<AnyCancellable>()
  
    init(dataFetcher: DataFetchable,
         scheduler: DispatchQueue = DispatchQueue(label: "CalendarViewModel")) {
        self.dataFetcher = dataFetcher
    }
    
//    func fetchInstalls() -> [Installation] {
    func fetchInstalls() -> Void {
        Firestore.firestore().collection("teams").document("2YRtIFLhYdTe7UNCvoVz").collection("installations").document("zeKjtHNgEwKPEnxyIi5i").getDocument { document, error in
            if let document = document {
                let install = try! FirestoreDecoder().decode(Installation.self, from: document.data() ?? [:])
                print("Installation: \(install)")
                self.installList = [install]
            } else {
                print("Document does not exist")
            }
        }
    }
}
