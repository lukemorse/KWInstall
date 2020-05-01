//
//  FloorPlanDetailView.swift
//  KW Install
//
//  Created by Luke Morse on 4/9/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct FloorPlanDetailView: View {
    
    
    let floorPlanImage: Image
    let floorPlanIndex: Int
//    @State var pods: [Pod]
    @ObservedObject var viewModel: FloorPlanViewModel
//    @State var podNodeViews: [PodNodeView] = []
    
    @State var tappedPodIndex: Int?
    @State var showImagePicker: Bool = false
    @State var image: Image? = nil
    
    @State var scale: CGFloat = 1.0
    @State var newScaleValue: CGFloat = 1.0
    @State var lastScaleValue: CGFloat = 1.0
    
    @State var tapPoint: CGPoint = CGPoint.zero
    @State var dragSize: CGSize = CGSize.zero
    @State var lastDrag: CGSize = CGSize.zero
    
    init(with floorPlanImage: Image, viewModel: FloorPlanViewModel, index: Int) {
        self.floorPlanImage = floorPlanImage
        self.viewModel = viewModel
        self.floorPlanIndex = index
    }
    
    var body: some View {
        VStack {
            ZStack {
                floorPlanImage
                    .resizable()
                
                podGroup
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
                self.viewModel.uploadPodImage(image: image) { (url) in
                    //store URL?
                    //                    print(url)
                }
                if let podIndex = self.tappedPodIndex {
                    self.viewModel.pods[self.floorPlanIndex][podIndex].isComplete = true
                    self.tappedPodIndex = nil
                }
            }
        }
    }
    
    var podGroup: some View {
        Group {
            ForEach (0..<self.viewModel.pods[self.floorPlanIndex].count, id: \.self) { idx in
                PodNodeView(pod: self.viewModel.pods[self.floorPlanIndex][idx])
                    .onTapGesture {
                        self.tappedPodIndex = idx
                        self.showImagePicker = true
                }
            }
        }
    }
}

struct FloorPlanDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FloorPlanDetailView(with: Image( "floorPlan"), viewModel: FloorPlanViewModel(installation: Installation()), index: 0)
            .previewLayout(.fixed(width: 568, height: 320))
    }
}
