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
                                ForEach(0..<self.viewModel.floorPlanThumbnails.chunked(into: 3)[row].count) { column in // create 3 columns
                                    
                                    Image(uiImage: self.viewModel.floorPlanThumbnails[column])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geometry.size.width / 3.5)
                                        .onTapGesture {
                                            self.selectedImageIndex = row * 3 + column
                                            print(index)
                                            self.pushDetailView = true
                                            print(self.viewModel.pods)
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
            navLink
            
        }
        .onAppear() {
            self.viewModel.getFloorPlans()
        }
    }
    
    var navLink : some View {
        if self.viewModel.floorPlanThumbnails.count > 0 {
            return AnyView(NavigationLink("", destination: FloorPlanDetailView(with: Image(uiImage: self.viewModel.floorPlanThumbnails[self.selectedImageIndex]), pods: self.viewModel.pods[self.selectedImageIndex], viewModel: self.viewModel), isActive: self.$pushDetailView).hidden())
        } else {
            return AnyView(EmptyView())
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


//struct FloorPlanGridView_Previews: PreviewProvider {
//    static var previews: some View {
//        FloorPlanGridView( pods: [])
//    }
//}



