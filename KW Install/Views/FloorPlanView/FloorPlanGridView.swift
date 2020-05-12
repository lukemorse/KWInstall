//
//  FloorPlanGridView.swift
//  KW Install
//
//  Created by Luke Morse on 4/3/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct FloorPlanGridView: View {
    @ObservedObject var viewModel: FloorPlanViewModel
    
    @State var pushDetailView = false
    @State var selectedImageIndex = 0
    
    var body : some View {
        VStack {
            GeometryReader { geometry in
                List {
                    if self.viewModel.floorPlanThumbnails.count > 0 {
                        ForEach(0..<self.viewModel.floorPlanThumbnails.chunked(into: 3).count) { row in // create number of rows
                            HStack {
                                ForEach(0..<self.viewModel.floorPlanThumbnails.chunked(into: 3)[row].count, id: \.self) { column in // create 3 columns
                                    
                                    Image(uiImage: self.viewModel.floorPlanThumbnails[column])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geometry.size.width / 3.5)
                                        .onTapGesture {
                                            self.selectedImageIndex = row * 3 + column
                                            self.pushDetailView = true
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
            getNavLink()
        }
        .onAppear() {
            self.viewModel.getFloorPlans()
            print("\(self.viewModel.floorPlanThumbnails.count) flooorplan images")
        }
    }
    
//    func getNavLink() -> some View {
//        return NavigationLink("", destination:
//            self.viewModel.floorPlanThumbnails.count > 0 ? Text("hi") : Text("ho"), isActive: self.$pushDetailView)
//    }
    
    func getNavLink() -> some View {
        return AnyView(NavigationLink("", destination:
            self.viewModel.floorPlanThumbnails.count > 0 ?
            AnyView(FloorPlanDetailView(with: Image(uiImage: self.viewModel.floorPlanThumbnails[self.selectedImageIndex]), viewModel: self.viewModel, index: self.selectedImageIndex))
                : AnyView(Text("error")), isActive: self.$pushDetailView).hidden())
    }
    
}

struct FloorPlanGridView_Previews: PreviewProvider {
    static var previews: some View {
        FloorPlanGridView( viewModel: FloorPlanViewModel(installation: Installation()))
    }
}
