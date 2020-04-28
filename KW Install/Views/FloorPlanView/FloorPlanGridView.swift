//
//  FloorPlanGridView.swift
//  KW Install
//
//  Created by Luke Morse on 4/3/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI


let items: [String] = ["1", "2", "3", "4", "5", "6", "7", "8"]
let chunked = items.chunked(into: 3)

struct FloorPlanGridView: View {
    @State var pushDetailView = false
    @State var selectedImageIndex = 0
    @ObservedObject var viewModel = FloorPlanViewModel(docID: "-6684770634346624996")
    
    var body : some View {
        
        VStack {
            GeometryReader { geometry in
                List {
                    if self.viewModel.floorPlanThumbnails.count > 0 {
                        ForEach(0..<self.viewModel.floorPlanThumbnails.chunked(into: 3).count) { row in // create number of rows
                            HStack {
                                ForEach(0..<self.viewModel.floorPlanThumbnails.chunked(into: 3)[row].count) { column in // create 3 columns
                                    //                                Image("floorPlan")
                                    NavigationLink(destination: FloorPlanDetailView(floorPlanImage: Image(uiImage: self.viewModel.floorPlanThumbnails[column])), isActive: self.$pushDetailView) {
                                        Image(uiImage: self.viewModel.floorPlanThumbnails[column])
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: geometry.size.width / 3.5)
                                    }
                                }
                            }
                        }
                    }
                    else {
                        EmptyView()
                    }
                    
                }
            }
            .frame(height: 300)
            .padding()
            NavigationLink("", destination: FloorPlanDetailView(floorPlanImage: Image("floorPlan")), isActive: self.$pushDetailView).hidden()
            
        }
        .onAppear() {
            self.viewModel.getFloorPlans()
        }
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}


struct FloorPlanGridView_Previews: PreviewProvider {
    static var previews: some View {
        FloorPlanGridView()
    }
}
