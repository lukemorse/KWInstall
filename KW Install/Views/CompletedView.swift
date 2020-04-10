//
//  CompletedView.swift
//  KW Install
//
//  Created by Luke Morse on 4/6/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct CompletedView: View {
    
    var completedInstallations: [Installation] = []
    
    var body: some View {
        VStack {
            if completedInstallations.isEmpty {
                emptySection
            } else {
                List {
                    ForEach(0..<self.completedInstallations.count, id: \.self) {
                        Text(self.completedInstallations[$0].schoolName)
                            .font(.headline)
                            .padding(10)
                    }
                }
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

struct CompletedView_Previews: PreviewProvider {
    static var previews: some View {
        CompletedView()
    }
}
