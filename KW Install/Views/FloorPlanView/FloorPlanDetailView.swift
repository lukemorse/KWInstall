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
    @EnvironmentObject var floorPlanViewModel: FloorPlanViewModel
    @EnvironmentObject var mainViewModel: MainViewModel
    
    @State var tappedPodIndex: Int?
    @State var showImagePicker: Bool = false
    @State var image: Image? = nil
    
    @State var scale: CGFloat = 1.0
    @State var newScaleValue: CGFloat = 1.0
    @State var lastScaleValue: CGFloat = 1.0
    
    @State var tapPoint: CGPoint = CGPoint.zero
    @State var dragSize: CGSize = CGSize.zero
    @State var lastDrag: CGSize = CGSize.zero
    
    init(with floorPlanImage: Image, index: Int) {
        self.floorPlanImage = floorPlanImage
//        self.viewModel = viewModel
        self.floorPlanIndex = index
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                self.floorPlanImage
                        .resizable()
                    self.podGroup
                }
                .scaledToFit()
                .animation(.linear)
                .scaleEffect(self.scale)
                .offset(self.dragSize)
                .gesture(MagnificationGesture().onChanged { val in
                    let delta = val / self.lastScaleValue
                    self.lastScaleValue = val
                    self.scale = self.scale * delta
                    if self.scale < 1 {self.scale = 1}
                    
                }.onEnded { val in
                    // without this the next gesture will be broken
                    self.lastScaleValue = 1.0
                    if self.scale < 1 {self.scale = 1}
                    })
                    .simultaneousGesture(DragGesture(minimumDistance: 1, coordinateSpace: .local).onChanged({ val in
                        
                        self.tapPoint = val.startLocation
                        self.dragSize = CGSize(width: val.translation.width + self.lastDrag.width, height: val.translation.height + self.lastDrag.height)
                    })
                        .onEnded({ (val) in
                            self.dragSize = CGSize(width: val.translation.width + self.lastDrag.width, height: val.translation.height + self.lastDrag.height)
                            self.lastDrag = self.dragSize
                        }))
            
            .sheet(isPresented: self.$showImagePicker) {
                ImagePicker(sourceType: .camera) { image in
                    self.image = Image(uiImage: image)
                    self.floorPlanViewModel.uploadPodImage(image: image, floorNumber: self.floorPlanIndex, podType: self.floorPlanViewModel.pods[self.floorPlanIndex][self.tappedPodIndex ?? 0].podType.description) { (url) in
                        //store URL?
                        //                    print(url)
                    }
                    if let podIndex = self.tappedPodIndex {
                        self.floorPlanViewModel.pods[self.floorPlanIndex][podIndex].isComplete = true
                        self.tappedPodIndex = nil
                    }
                }
            }
        }
        .navigationBarItems(trailing: saveButton)
    }
    
    var saveButton: some View {
        Button(action: {
            if let installation = self.floorPlanViewModel.installation {
                self.mainViewModel.updatePods(for: installation, url: installation.floorPlanUrls[self.floorPlanIndex], pods: self.floorPlanViewModel.pods[self.floorPlanIndex])
            }
        }) {
            Text("Save")
                .foregroundColor(Color.blue)
        }
    }
    
    var podGroup: some View {
        Group {
            ForEach (0..<self.floorPlanViewModel.pods[self.floorPlanIndex].count, id: \.self) { idx in
                PodNodeView(pod: self.floorPlanViewModel.pods[self.floorPlanIndex][idx])
                    .onTapGesture {
                        self.tappedPodIndex = idx
                        self.showImagePicker = true
                }
            }
        }
    }
    
    func adjustPanForBoundaries(value: DragGesture.Value, geoProxy: GeometryProxy) -> CGSize {
        let offsetWidth = (geoProxy.frame(in: .global).maxX * self.scale - geoProxy.frame(in: .global).maxX) / 2
        let newDraggedWidth = self.dragSize.width * self.scale
        var resultWidth: CGFloat = 0
        let offsetHeight = (geoProxy.frame(in: .global).maxY * self.scale - geoProxy.frame(in: .global).maxY) / 2
        let newDraggedHeight = self.dragSize.height * self.scale
        var resultHeight: CGFloat = 0
        
        if newDraggedWidth > offsetWidth {
            resultWidth = offsetWidth / self.scale
        } else if newDraggedWidth < -offsetWidth {
            resultWidth = -offsetWidth / self.scale
        } else {
            resultWidth = value.translation.width + self.lastDrag.width
        }
            
        if newDraggedHeight > offsetHeight {
            resultHeight = offsetHeight / self.scale
        } else if newDraggedHeight < -offsetHeight {
            resultHeight = -offsetHeight / self.scale
        } else {
            resultHeight = value.translation.height + self.lastDrag.height
        }
        
        return CGSize(width: resultWidth, height: resultHeight)
    }
}

//struct FloorPlanDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        FloorPlanDetailView(with: Image( "floorPlan"), viewModel: FloorPlanViewModel(installation: Installation()), index: 0)
//
//    }
//}
