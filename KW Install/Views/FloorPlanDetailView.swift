//
//  FloorPlanDetailView.swift
//  KW Install
//
//  Created by Luke Morse on 4/9/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct FloorPlanDetailView: View {
    var floorPlanImage: Image
    var body: some View {
        floorPlanImage
            .resizable()
    }
}

struct FloorPlanDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FloorPlanDetailView(floorPlanImage: Image( "floorPlan"))
        .previewLayout(.fixed(width: 568, height: 320))
    }
}
