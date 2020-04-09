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
    @State var pushActive = false
    @State var selectedImageIndex = 0
    
    var body : some View {
        
        VStack {
            GeometryReader { geometry in
                
                List {
                    ForEach(0..<chunked.count) { row in // create number of rows
                        HStack {
                            ForEach(0..<chunked[row].count) { column in // create 3 columns
                                Image("floorPlan")
                                    
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geometry.size.width / 3)
                                    .onTapGesture {
//                                        AppDelegate.orientationLock = UIInterfaceOrientationMask.landscapeLeft
//
//                                        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft, forKey: "orientation")
//                                        UINavigationController.attemptRotationToDeviceOrientation()
                                        
                                        let index = row * 3 + column
                                        print(index)
                                        self.pushActive = true
                                        
                                        
                                }
                            }
                        }
                    }
                }
            }
            .frame(height: 300)
            .padding()
            NavigationLink("Show detail", destination: FloorPlanDetailView(floorPlanImage: Image("floorPlan")), isActive: self.$pushActive)
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
