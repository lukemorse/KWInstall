//
//  InstallationView.swift
//  KW Install
//
//  Created by Luke Morse on 4/3/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI
import MapKit
import Firebase
import MessageUI

struct InstallationView: View {
    var installation: Installation
    
    @State var mailResult: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    @State private var centerCoordinate = CLLocationCoordinate2D()
    
    var body: some View {
        ScrollView {
            VStack {
                ZStack {
                    makeMap(geoPoint: installation.address)
                }
                Text(installation.districtName + ": " + installation.schoolName)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 10.0)
                Text("Quick Information:")
                    .font(.headline)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 10.0)
                
                Group {
                    Text("School Contact Person: " + installation.schoolContact)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("District Contact Person: " + installation.districtContact).frame(maxWidth: .infinity, alignment: .leading)
                    Text("Number of Floors: " + String(installation.numFloors)).frame(maxWidth: .infinity, alignment: .leading)
                    Text("Number of Rooms: " + String(installation.numRooms)).frame(maxWidth: .infinity, alignment: .leading)
                    Text("Number of KW-PODS Needed: " + String(installation.numPods)).frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, 10.0)
                
                Button(action: {
                    self.isShowingMailView.toggle()
                })
                {
                    Text("Send En-Route Message")
                        .font(.headline)
                        .padding(10.0)
                        .foregroundColor(Color.black)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .disabled(!MFMailComposeViewController.canSendMail())
                .sheet(isPresented: $isShowingMailView) {
                    MailView(result: self.$mailResult)
                }
                
                Text("Floorplans:")
                FloorPlanGridView()
//                Spacer()
            }
            .padding()
        }
    }
    
    func makeMap(geoPoint: GeoPoint) -> some View {
        
        //        let centerCoordinate = CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
        return MapView(centerCoordinate:
            $centerCoordinate)
            .frame(height: 200)
            .edgesIgnoringSafeArea(.top)
    }
    
    //Mail Stuff
    
    //    private func mailView() -> some View {
    //        MFMailComposeViewController.canSendMail() ?
    //            AnyView(MailView(isShowing: $isShowingMailView, result: $mailResult)) :
    //            AnyView(Text("Can't send emails from this device"))
    //    }
    
    
}

struct InstallationView_Previews: PreviewProvider {
    static var previews: some View {
        InstallationView(installation: Installation(address: GeoPoint(latitude: 20, longitude: 20), completed: false, districtContact: "", districtName: "", schoolContact: "", schoolName: "", email: "", numFloors: 1, numRooms: 1, numPods: 1, timeStamp: Timestamp(date: Date())))
    }
}

