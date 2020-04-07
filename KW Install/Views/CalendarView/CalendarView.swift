//
//  CalendarView.swift
//  KW Install
//
//  Created by Luke Morse on 4/2/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct CalendarView : View {
    @ObservedObject var viewModel: CalendarViewModel
    init(viewModel: CalendarViewModel) {
        self.viewModel = viewModel
    }
    
    @State var isPresented = true
    
    var rkManager = RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0)
    
    var body: some View {
            VStack {
                if viewModel.installList.isEmpty {
                    emptySection
                } else {
                    installListView
                }
                
                RKViewController(isPresented: $isPresented, rkManager: self.rkManager)
            }
                
                .onAppear() {
                    self.viewModel.fetchInstalls()
            }
//        }
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
}

// Update UI
extension CalendarView {
    var installListView: some View {
        
        //        NavigationView {
        List(0..<viewModel.installList.count) { row in
            VStack {
                NavigationLink(destination: InstallationView(installation: self.viewModel.installList[row])) {
                    Text(self.viewModel.installList[row].schoolName)
                }
                //                    .navigationBarTitle("Installation Detail")
            }
            
        }
        //        }
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
        CalendarView(viewModel: CalendarViewModel(dataFetcher: DataFetcher()))
    }
}
#endif

