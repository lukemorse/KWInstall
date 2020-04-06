//
//  CompletedView.swift
//  KW Install
//
//  Created by Luke Morse on 4/6/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct CompletedView: View {
    
    var completeList: [String] = ["George Westinghouse College Prep", "Gwendolyn Brooks College","John Hancock College"]
    var body: some View {
        VStack {
            HStack {
                Image("Logo")
                Text("COMPLETED")
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
            }
            
            List {
                ForEach(0..<completeList.count, id: \.self) {
                    Text(self.completeList[$0])
                        .font(.headline)
                        .padding(10)
                }
            }
            
            Spacer()
        }
    }
}

struct CompletedView_Previews: PreviewProvider {
    static var previews: some View {
        CompletedView()
    }
}
