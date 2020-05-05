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
    @Published var installationDictionary: [Date: [Installation]] = [:]
}
