//
//  FloorPlanDetailView.swift
//  KW Install
//
//  Created by Luke Morse on 4/9/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct FloorPlanDetailView: View {
    
    @State var showImagePicker: Bool = false
    @State var image: Image? = nil
    
    @State var scale: CGFloat = 1.0
    @State var newScaleValue: CGFloat = 1.0
    @State var lastScaleValue: CGFloat = 1.0
    
    @State var tapPoint: CGPoint = CGPoint.zero
    @State var dragSize: CGSize = CGSize.zero
    @State var lastDrag: CGSize = CGSize.zero
    
    var floorPlanImage: Image
    var body: some View {
        VStack {
            ZStack {
                floorPlanImage
                    .resizable()
                
                Button(action: {
                    print("button clicked")
                    self.showImagePicker.toggle()
                }) {
                    Circle().fill(Color.red)
                }
                .onTapGesture {
                    print("button clicked")
                    self.showImagePicker.toggle()
                }
                .frame(width: 10.0, height: 10.0)
                .background(Color.red)
                .mask(Circle())
                .position(CGPoint(x: 200, y: 200))
            }
            .scaledToFit()
            .animation(.linear)
            .scaleEffect(self.scale)
            .offset(dragSize)
            .gesture(MagnificationGesture().onChanged { val in
                let delta = val / self.lastScaleValue
                self.lastScaleValue = val
                self.scale = self.scale * delta

            }.onEnded { val in
                // without this the next gesture will be broken
                self.lastScaleValue = 1.0
                }

            )
                .simultaneousGesture(DragGesture(minimumDistance: 0, coordinateSpace: .global).onChanged({ val in
                self.tapPoint = val.startLocation
                self.dragSize = CGSize(width: val.translation.width + self.lastDrag.width, height: val.translation.height + self.lastDrag.height)
            })
                .onEnded({ (val) in
                    self.dragSize = CGSize(width: val.translation.width + self.lastDrag.width, height: val.translation.height + self.lastDrag.height)
                    self.lastDrag = self.dragSize
                }))
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: .camera) { image in
                self.image = Image(uiImage: image)
            }
        }
    }
    
}

struct FloorPlanDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FloorPlanDetailView(floorPlanImage: Image( "floorPlan"))
            .previewLayout(.fixed(width: 568, height: 320))
    }
}
