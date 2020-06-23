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
    @EnvironmentObject var mainViewModel: MainViewModel
    @ObservedObject var rkManager = RKManager(calendar: Calendar.current, minimumDate: Date().addingTimeInterval(-60*60*24*7), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0)
    @State var isLoading = false
    
    var body: some View {
        Group {
            installationListView
            RKViewController(isPresented: .constant(true), rkManager: self.rkManager)
        }
        .onAppear() {
            self.rkManager.onDateTapped = {date in
                self.viewModel.fetchInstallations(for: date.formatForDB(), isMaster: self.mainViewModel.isMasterAccount, teamName: self.mainViewModel.team?.name ?? "")
            }
        }
    }
    
    var installationListView : some View {
        if viewModel.installations.count > 0 {
            return AnyView(
                List {
                    ForEach(self.viewModel.installations, id: \.self) {install in
                        VStack {
                            NavigationLink(destination: InstallationView(viewModel: InstallationViewModel(schoolName: install.schoolName, districtID: install.districtID, docID: install.installationID))
                            ) {
                                Text(install.schoolName)
                            }
                        }
                        .padding()
                    }
                }
            )
        }

        return AnyView(List {
            Text(isLoading ? "Loading..." : "No Installations")
                .padding()
        })
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

