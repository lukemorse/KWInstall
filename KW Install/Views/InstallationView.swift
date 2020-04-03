//
//  InstallationView.swift
//  KW Install
//
//  Created by Luke Morse on 4/3/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI
import MapKit

struct InstallationView: View {
    @State private var centerCoordinate = CLLocationCoordinate2D()
    
    var body: some View {
        VStack() {
            ZStack {
                MapView(centerCoordinate: $centerCoordinate)
                    .frame(height: 200)
                    .edgesIgnoringSafeArea(.top)
//                Circle()
//                    .fill(Color.blue)
//                    .opacity(0.3)
//                    .frame(width: 32, height: 32)
            }
            Text("School Name/District Name")
                .font(.title)
                .multilineTextAlignment(.center)
                .padding(.vertical, 10.0)
            Text("Quick Information:")
                .font(.headline)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.vertical, 10.0)
            
            Group {
                Text("School Contact Person: ")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("District Contact Person: ").frame(maxWidth: .infinity, alignment: .leading)
                Text("Number of Floors: ").frame(maxWidth: .infinity, alignment: .leading)
                Text("Number of Rooms: ").frame(maxWidth: .infinity, alignment: .leading)
                Text("Number of KW-PODS Needed: ").frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 10.0)
            
            Button(action: {}) {Text("Send En-Route Message")
                .font(.headline)
                .padding(10.0)
                .foregroundColor(Color.black)}
                .background(Color.blue)
                .cornerRadius(10)
            Text("Floorplans:")
            CollectionView()
            Spacer()
        }
        .padding()
    }
}

struct InstallationView_Previews: PreviewProvider {
    static var previews: some View {
        InstallationView()
    }
}
