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
    @EnvironmentObject var mainViewModel: MainViewModel
    @Binding var installation: Installation
    @ObservedObject var floorPlanViewModel: FloorPlanViewModel
    @State var mailResult: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    
    init(installation: Binding<Installation>) {
        self.floorPlanViewModel = FloorPlanViewModel(installation: installation.wrappedValue)
        self._installation = installation
    }
    
    var body: some View {
        
        return VStack() {
            ScrollView {
                makeMap(geoPoint: installation.address)
                    .onTapGesture {
                        self.openMapsAppWithDirections(to: CLLocationCoordinate2D(latitude: self.installation.address.latitude, longitude: self.installation.address.longitude))
                }
                statusPicker
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
                
                sendEMailButton.padding()
                
                Text("Floorplans:")
                FloorPlanGridView(viewModel: floorPlanViewModel)
//                NavLinkTest(viewModel: navLinkTestViewModel)
                Spacer()
            }
        }
        .padding()
    }
    
    var statusPicker: some View {
        let stati = Binding<InstallationStatus>(
            get: {return self.installation.status},
            set: {
                self.installation.status = $0
                self.mainViewModel.updateInstallationStatus(for: self.installation)
        })
        
        return Picker(selection: stati, label: Text("Status")) {
            ForEach(InstallationStatus.allCases) { status in
                Text(status.description).tag(status)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
    
    var sendEMailButton: some View {
        Button(action: {
            self.isShowingMailView.toggle()
        })
        {
            Text("Send En-Route Message")
                .font(.headline)
                .padding(10.0)
                .foregroundColor(Color.black)
                .background(Color.blue)
                .cornerRadius(5)
        }
        .disabled(!MFMailComposeViewController.canSendMail())
        .sheet(isPresented: $isShowingMailView) {
            MailView(emails: [self.installation.email], result: self.$mailResult)
        }
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

//struct InstallationView_Previews: PreviewProvider {
//    static var previews: some View {
//        InstallationView(installation: .constant(Installation()))
//    }
//}
