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
    // 2
    @Published var installList: [Installation] = []
    @Published var installRefs: [DocumentReference] = []
    
    func fetchInstalls() -> Void {
        print("Fetch instlls")
        if installRefs.isEmpty {return}
        for ref in installRefs {
            ref.getDocument { document, error in
                if let document = document {
                    let install = try! FirestoreDecoder().decode(Installation.self, from: document.data() ?? [:])
                    print("Installation: \(install)")
                    self.installList.append(install)
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
}
