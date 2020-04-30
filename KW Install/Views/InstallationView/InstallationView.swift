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
    
    var body: some View {
        VStack() {
            ScrollView {
                makeMap(geoPoint: installation.address)
                    .onTapGesture {
                        self.openMapsAppWithDirections(to: CLLocationCoordinate2D(latitude: self.installation.address.latitude, longitude: self.installation.address.longitude))
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
                FloorPlanGridView(viewModel: FloorPlanViewModel(installation: installation))
                Spacer()
            }
        }
        .padding()
    }
    
    func makeMap(geoPoint: GeoPoint) -> some View {
        return MapView(centerCoordinate: CLLocationCoordinate2D(latitude: installation.address.latitude, longitude: installation.address.longitude))
            .frame(height: 200)
            .edgesIgnoringSafeArea(.top)
        
    }
    
    func openMapsAppWithDirections(to coordinate: CLLocationCoordinate2D) {
        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = installation.schoolName
        mapItem.openInMaps(launchOptions: options)
    }
    
}

struct InstallationView_Previews: PreviewProvider {
    static var previews: some View {
        InstallationView(installation: Installation())
    }
}
