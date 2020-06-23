//
//  CompletedView.swift
//  KW Install
//
//  Created by Luke Morse on 4/6/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct CompletedView: View {
    
    @ObservedObject var viewModel: MainViewModel
    @State var isLoading = false
    
    var body: some View {
        installationListView
            .onAppear() {
                self.isLoading = true
                self.viewModel.fetchCompletedInstallations() {
                    self.isLoading = false
                }
        }
    }
    
    var installationListView: some View {
        if viewModel.completedInstalls.count > 0 {
            return
                AnyView(List {
                    ForEach(viewModel.completedInstalls, id: \.self) {install in
                        NavigationLink(destination: InstallationView(viewModel: InstallationViewModel(installation: install))) {
                            Text(install.schoolName)
                        }
                    }
                })
        }
        return AnyView(emptySection)
    }
    
    var emptySection: some View {
        Section {
            Text(isLoading ? "Loading..." : "No results")
                .foregroundColor(.gray)
        }
    }
}

struct CompletedView_Previews: PreviewProvider {
    static var previews: some View {
        return CompletedView(viewModel: MainViewModel())
    }
}
