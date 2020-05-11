//
//  CalendarView.swift
//  KW Install
//
//  Created by Luke Morse on 4/2/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI
import Firebase

struct CalendarView : View {
    
    @EnvironmentObject var mainViewModel: MainViewModel
    
    @ObservedObject var rkManager = RKManager(calendar: Calendar.current, minimumDate: Date().addingTimeInterval(-60*60*24*7), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0)
    
    var body: some View {
        Group {
            installationListView
            RKViewController(isPresented: .constant(true), rkManager: self.rkManager)
//            self.mainViewModel.
        }
    }
    
    var installationListView : some View {
        if let arr = mainViewModel.installationDictionary[self.rkManager.selectedDate] {
            if arr.count > 0 {
                return AnyView(List {
                    ForEach(0..<arr.count, id: \.self) {index in
                        VStack {
                            self.getNavLink(index: index, label: arr[index].schoolName)
                        }
                    }
                })
            }
        }
        
        return AnyView(List {Text("No Installations")})
    }
    
    func getNavLink(index: Int, label: String) -> some View {
        return NavigationLink(destination: InstallationView(
            installation: self.mainViewModel.getInstallation(date: self.rkManager.selectedDate, index: index)
        )) {
            Text(label)
        }
    }
    
    func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
    
    
    //Calendar
    func datesView(dates: [Date]) -> some View {
        ScrollView (.horizontal) {
            HStack {
                ForEach(dates, id: \.self) { date in
                    Text(self.getTextFromDate(date: date))
                }
            }
        }.padding(.horizontal, 15)
    }
    
    func getTextFromDate(date: Date!) -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        return date == nil ? "" : formatter.string(from: date)
    }
    
    var emptySection: some View {
        Section {
            Text("No results")
                .foregroundColor(.gray)
        }
    }
}


#if DEBUG
struct CalendarView_Previews : PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
#endif

