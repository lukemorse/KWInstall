//
//  ContactsView.swift
//  KW Install
//
//  Created by Luke Morse on 4/6/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct ContactsView: View {
    
    var team: Team?
    
    var body: some View {
        VStack {
            if (team != nil) {
                List {
                    Text("Team Leader: " + self.team!.leader)
                    .font(.headline)
                    .padding(10)
                    
                    if team!.members.count > 0 {
                            ForEach(0..<team!.members.count, id: \.self) {
                                Text(self.team!.members[$0].name)
                                    .font(.headline)
                                    .padding(10)
                            }
                    } else {
                        Section {
                            Text("No team members")
                                .foregroundColor(.gray)
                        }
                    }
                }
            } else {
                emptySection
            }
            
            Spacer()
        }
    }
    
    var emptySection: some View {
        Section {
            Text("No results")
                .foregroundColor(.gray)
        }
    }
}
