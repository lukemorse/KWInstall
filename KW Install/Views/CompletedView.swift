//
//  CompletedView.swift
//  KW Install
//
//  Created by Luke Morse on 4/6/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct CompletedView: View {
    
    @EnvironmentObject var mainViewModel: MainViewModel
    
    var body: some View {
        var completedInstalls: [Installation] = []
        let districtArrays = Array(mainViewModel.installationDictionary.values)
        for schoolArrays in districtArrays {
            for installation in schoolArrays {
                if installation.status == InstallationStatus.complete {
                    completedInstalls.append(installation)
                }
            }
        }
        
        return VStack {
            if completedInstalls.isEmpty {
                emptySection
            } else {
                List {
                    ForEach(0..<completedInstalls.count, id: \.self) {index in
                        VStack {
                            self.getNavLink(installation: completedInstalls[index])
                        }
                        .padding()
                    }
                }
            }
            Spacer()
        }
    }
    
    func getNavLink(installation: Installation) -> some View {
        return NavigationLink(destination: InstallationView(
            installation: self.mainViewModel.getInstallation(installation: installation) ?? .constant(installation)))
         {
            Text(installation.schoolName)
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
        return CompletedView().environmentObject(MainViewModel())
    }
}
