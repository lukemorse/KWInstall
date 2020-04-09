//
//  ContactsViewModel.swift
//  KW Install
//
//  Created by Luke Morse on 4/7/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI
import Combine
import Firebase
import CodableFirebase
//
//class ContactsViewModel: ObservableObject {
//  // 2
//    @Published var teamLeader: User
//    @Published var members: [User] = []
//    
//    func fetchInstalls() -> Void {
//        Firestore.firestore().collection("teams").document("2YRtIFLhYdTe7UNCvoVz").collection("installations").document("zeKjtHNgEwKPEnxyIi5i").getDocument { document, error in
//            if let document = document {
//                let install = try! FirestoreDecoder().decode(Installation.self, from: document.data() ?? [:])
//                print("Installation: \(install)")
//            } else {
//                print("Document does not exist")
//            }
//        }
//    }
//}
