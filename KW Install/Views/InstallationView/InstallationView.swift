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
    @ObservedObject var viewModel: InstallationViewModel
    @State var mailResult: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    
    init(viewModel: InstallationViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack() {
            ScrollView {
                mapView
                schoolLabel
                statusPicker
                quickInfoTitle
                quickInfo
                sendMessageButton
                .disabled(!MFMailComposeViewController.canSendMail())
                .sheet(isPresented: $isShowingMailView) {
                    MailView(emails: [self.viewModel.installation.email], result: self.$mailResult)
                }
                floorPlansTitle
                floorPlanGridView
                Spacer()
            }
        }
        .padding()
    }
    
    var schoolLabel: some View {
        Text(viewModel.installation.districtName + ": " + viewModel.installation.schoolName)
        .font(.title)
        .multilineTextAlignment(.center)
        .padding(.vertical, 10.0)
    }
    
    var quickInfoTitle: some View {
        Text("Quick Information:")
            .font(.title)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .padding(.vertical, 10.0)
    }
    
    var quickInfo: some View {
        Group {
            Text("School Contact Person: " + viewModel.installation.schoolContact)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("District Contact Person: " + viewModel.installation.districtContact).frame(maxWidth: .infinity, alignment: .leading)
            Text("Number of Floors: " + String(viewModel.installation.numFloors)).frame(maxWidth: .infinity, alignment: .leading)
            Text("Number of Rooms: " + String(viewModel.installation.numRooms)).frame(maxWidth: .infinity, alignment: .leading)
            Text("Number of KW-PODS Needed: " + String(viewModel.installation.numPods)).frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 10.0)
    }
    
    var sendMessageButton: some View {
        Button(action: {
            self.isShowingMailView.toggle()
        })
        {
            Text("Send En-Route Message")
                .font(.title)
                .padding(10.0)
                .foregroundColor(Color.black)
                .background(Color.blue)
                .cornerRadius(15)
        }
        .padding(.vertical, 20)
    }
    
    var floorPlansTitle: some View {
        Text("Floorplans:")
            .font(.title)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .padding(.vertical, 10.0)
    }
    
    var floorPlanGridView: some View {
        FloorPlanGridView(installID: self.viewModel.installation.installationID, urls:
            viewModel.installation.floorPlanUrls.compactMap { URL(string: $0) }
        )
    }
    
    var statusPicker: some View {
        let binding = Binding<InstallationStatus>(get: {return self.viewModel.installation.status}, set: {
            self.viewModel.setStatus(status: $0)
            self.viewModel.installation.status = $0})
        
        return Picker(selection: binding, label: Text("Status")) {
            ForEach(InstallationStatus.allCases) { status in
                Text(status.description).tag(status)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
    
    var mapView: some View {
        MapView(address: self.viewModel.installation.address) {
            (gesture, location) in
            self.openMapsAppWithDirections(to: location)
        }
        .frame(height: 200)
        .edgesIgnoringSafeArea(.top)
    }
    
    func openMapsAppWithDirections(to coordinate: CLLocationCoordinate2D) {
        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = viewModel.installation.schoolName
        mapItem.openInMaps(launchOptions: options)
    }
    
}

struct InstallationView_Previews: PreviewProvider {
    static var previews: some View {
        InstallationView(viewModel: InstallationViewModel(installation: Installation(districtID: "123"))).environmentObject(MainViewModel())
    }
}
