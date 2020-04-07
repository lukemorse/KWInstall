//
//  ContactsView.swift
//  KW Install
//
//  Created by Luke Morse on 4/6/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct ContactsView: View {
    
    var contacts: [String] = ["Team Leader: (Name)", "Name","Name","Name"]
    var body: some View {
        VStack {
            List {
                ForEach(0..<contacts.count, id: \.self) {
                    Text(self.contacts[$0])
                        .font(.headline)
                        .padding(10)
                }
            }
            
            Spacer()
        }
    }
}



struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView()
    }
}
