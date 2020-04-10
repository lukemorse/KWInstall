//
//  MainView.swift
//  KW Install
//
//  Created by Luke Morse on 4/2/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var viewModel: MainViewModel
    @State var selected = 0
    
    init() {
        viewModel = MainViewModel(calendarViewModel: CalendarViewModel())
    }
    
    var body: some View {
        TabView(selection: $selected) {
            
            //Calendar
            NavigationView {
                CalendarView(viewModel: viewModel.calendarViewModel)
                    .navigationBarTitle(
                    Text("Today's Installations"), displayMode: .inline)
                .navigationBarItems(leading:
                    Image("Logo")
                        .frame(height: nil)
                        
                        )
            }
            .tabItem({
                Image(systemName: Constants.TabBarImageName.tabBar0)
                    .font(.title)
                Text("\(Constants.TabBarText.tabBar0)")
            }).tag(0)
            
            //Team Contacts
            NavigationView {
                ContactsView(team: viewModel.teamData).navigationBarTitle(
                    Text("Team"), displayMode: .inline)
                .navigationBarItems(leading:
                    Image("Logo")
                        .fixedSize())
            }
            .tabItem({
                Image(systemName: Constants.TabBarImageName.tabBar1)
                    .font(.title)
                Text("\(Constants.TabBarText.tabBar1)")
            }).tag(1)
            
            //Completed
            NavigationView {
                CompletedView(completedInstallations: viewModel.completedInstallations  ).navigationBarTitle(
                    Text("Completed"), displayMode: .inline)
                .navigationBarItems(leading:
                    Image("Logo")
                        .fixedSize())
            }
            .tabItem({
                Image(systemName: Constants.TabBarImageName.tabBar2)
                    .font(.title)
                Text("\(Constants.TabBarText.tabBar2)")
            }).tag(2)
            
            //Reference
            NavigationView {
                ReferencesView().navigationBarTitle(
                    Text("References"), displayMode: .inline)
                .navigationBarItems(leading:
                    Image("Logo")
                        .fixedSize())
            }
            .tabItem({
                Image(systemName: Constants.TabBarImageName.tabBar3)
                    .font(.title)
                Text("\(Constants.TabBarText.tabBar3)")
            }).tag(3)
            
        }.accentColor(Color.red)
            .onAppear(){
                self.viewModel.fetchTeamData()
//                self.viewModel.getCompletedInstallations()
//                self.viewModel.getInstallations()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
