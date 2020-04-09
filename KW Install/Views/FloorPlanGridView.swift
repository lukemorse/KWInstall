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
    
    var body : some View {
        let items: [String] = ["1", "2", "3", "4", "5", "6", "7", "8"]
        let chunked = items.chunked(into: 3)
        
        return GeometryReader { geometry in
            
            List {
                ForEach(0..<chunked.count) { row in // create number of rows
                    HStack {
                        ForEach(0..<chunked[row].count) { column in // create 3 columns
                            Image("floorPlan")
                            .resizable()
                            .scaledToFill()
                                .frame(width: geometry.size.width / 3)
                        }
                    }
                }
            }
        }
        .frame(height: 300)
        .padding()
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
