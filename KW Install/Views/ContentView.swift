//
//  ContentView.swift
//  KW Install
//
//  Created by Luke Morse on 4/2/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var selected = 1
    
    var body: some View {
        TabView(selection: $selected) {
            Text("\(Constants.TabBarText.tabBar0)").tabItem({
                Image(systemName: Constants.TabBarImageName.tabBar0)
                    .font(.title)
                Text("\(Constants.TabBarText.tabBar0)")
            }).tag(0)
            
            Text("\(Constants.TabBarText.tabBar1)").tabItem({
                Image(systemName: Constants.TabBarImageName.tabBar1)
                    .font(.title)
                Text("\(Constants.TabBarText.tabBar1)")
            }).tag(1)
            
            Text("\(Constants.TabBarText.tabBar2)").tabItem({
                Image(systemName: Constants.TabBarImageName.tabBar2)
                    .font(.title)
                Text("\(Constants.TabBarText.tabBar2)")
            }).tag(2)
            
            Text("\(Constants.TabBarText.tabBar3)").tabItem({
                Image(systemName: Constants.TabBarImageName.tabBar3)
                    .font(.title)
                Text("\(Constants.TabBarText.tabBar3)")
            }).tag(3)
            
            Text("\(Constants.TabBarText.tabBar4)").tabItem({
                Image(systemName: Constants.TabBarImageName.tabBar4)
                    .font(.title)
                Text("\(Constants.TabBarText.tabBar4)")
            }).tag(4)
            
        }.accentColor(Color.red)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
