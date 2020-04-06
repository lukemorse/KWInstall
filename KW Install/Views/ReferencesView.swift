//
//  ReferencesView.swift
//  KW Install
//
//  Created by Luke Morse on 4/6/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct ReferencesView: View {
    
    var body: some View {
        VStack {
            HStack {
                Image("Logo")
                Text("REFERENCES")
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
            }
            Spacer()
        }
    }
}

struct ReferencesView_Previews: PreviewProvider {
    static var previews: some View {
        ReferencesView()
    }
}
