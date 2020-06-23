//
//  AlertItem.swift
//  KW Install
//
//  Created by Luke Morse on 6/23/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct AlertItem: Identifiable {
    var id = UUID()
    var title: Text
    var message: Text?
    var dismissButton: Alert.Button?
}
