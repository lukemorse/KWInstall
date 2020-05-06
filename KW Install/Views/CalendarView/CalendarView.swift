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
    
    @ObservedObject var viewModel: CalendarViewModel
    @State var isPresented = true
    
    @ObservedObject var rkManager = RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0)
    
    var body: some View {
            Group {
                installationListView
                RKViewController(isPresented: $isPresented, rkManager: self.rkManager)
            }
    }
    
    var installationListView : some View {
        print(viewModel.installationDictionary.count)
        print(viewModel.installationDictionary)
        if let selectedDate = self.rkManager.selectedDate {
            if let arr = viewModel.installationDictionary[selectedDate] {
                print(arr)
                if arr.count > 0 {
                    return AnyView(List {
                        ForEach(0..<arr.count, id: \.self) {index in
                            VStack {
                                NavigationLink(destination: InstallationView(installation: arr[index])) {
                                    Text(arr[index].schoolName)
                                }
                            }
                        }
                    })
                }
            }
        }
        
        return AnyView(List {Text("No Installations")})
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
        CalendarView(viewModel: CalendarViewModel())
    }
}
#endif

