//
//  FloorPlanDetailView.swift
//  KW Install
//
//  Created by Luke Morse on 4/9/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//



import SwiftUI

struct FloorPlanDetailView: View {
    @Environment(\.imageCache) var cache: ImageCache
    @ObservedObject var viewModel: FloorPlanViewModel
    
    @State var alertItem: AlertItem?
    @State var tappedPodIndex: Int?
    @State var showPodUrl: String?
    @State private var showSheet = false
    @State private var activeSheet: ActiveSheet = .camera
    
    @State var scale: CGFloat = 1.0
    @State var newScaleValue: CGFloat = 1.0
    @State var lastScaleValue: CGFloat = 1.0
    
    @State var tapPoint: CGPoint = CGPoint.zero
    @State var dragSize: CGSize = CGSize.zero
    @State var lastDrag: CGSize = CGSize.zero
    
    init(with floorPlanViewModel: FloorPlanViewModel) {
        self.viewModel = floorPlanViewModel
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                AsyncImage(url: self.viewModel.url, cache: self.cache, placeholder: Text("Loading..."), configuration: {$0.resizable()})
                    self.podGroup
                }
                .scaledToFit()
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
                
                .sheet(isPresented: self.$showSheet) {
                    if self.activeSheet == ActiveSheet.camera {
                        ImagePicker(sourceType: .camera) { image in
                            if let podIndex = self.tappedPodIndex {
                                self.viewModel.uploadPodImage(image: image, podType: self.viewModel.pods[podIndex].podType.description) { url in
                                    self.viewModel.pods[podIndex].imageUrl = url
                                    self.viewModel.pods[podIndex].isComplete = true
                                    self.tappedPodIndex = nil
                                }
                            }
                        }
                    } else {
                        AsyncImage(
                            url: URL(string: self.showPodUrl!)!,
                            placeholder: Text("Loading ...")
                        )
                    }
            }
        }
        .navigationBarItems(trailing: saveButton)
        .onAppear() {
            self.viewModel.fetchPods()
        }
        .alert(item: $alertItem) {alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        }
    }
    
    var saveButton: some View {
        Button(action: {
            self.viewModel.setPods() { success in
                self.alertItem = AlertItem(title: Text(success ? "Saved Pods" : "Error Saving Pods"), message: nil, dismissButton: .cancel(Text("OK")))
            }
        }) {
            Text("Save")
                .foregroundColor(Color.blue)
        }
    }
    
    var podGroup: some View {
        Group {
            ForEach (0..<self.viewModel.pods.count, id: \.self) { index in
                PodNodeView(pod: self.viewModel.pods[index])
                    .onTapGesture {
                        if (self.viewModel.pods[index].isComplete) {
                            self.showPodUrl = self.viewModel.pods[index].imageUrl
                            self.activeSheet = ActiveSheet.imageView
                            self.showSheet = true
                        } else {
                            self.tappedPodIndex = index
                            self.activeSheet = ActiveSheet.camera
                            self.showSheet = true
                        }
                }
            }
        }
    }
    
//    func adjustPanForBoundaries(value: DragGesture.Value, geoProxy: GeometryProxy) -> CGSize {
//        let offsetWidth = (geoProxy.frame(in: .global).maxX * self.scale - geoProxy.frame(in: .global).maxX) / 2
//        let newDraggedWidth = self.dragSize.width * self.scale
//        var resultWidth: CGFloat = 0
//        let offsetHeight = (geoProxy.frame(in: .global).maxY * self.scale - geoProxy.frame(in: .global).maxY) / 2
//        let newDraggedHeight = self.dragSize.height * self.scale
//        var resultHeight: CGFloat = 0
//
//        if newDraggedWidth > offsetWidth {
//            resultWidth = offsetWidth / self.scale
//        } else if newDraggedWidth < -offsetWidth {
//            resultWidth = -offsetWidth / self.scale
//        } else {
//            resultWidth = value.translation.width + self.lastDrag.width
//        }
//
//        if newDraggedHeight > offsetHeight {
//            resultHeight = offsetHeight / self.scale
//        } else if newDraggedHeight < -offsetHeight {
//            resultHeight = -offsetHeight / self.scale
//        } else {
//            resultHeight = value.translation.height + self.lastDrag.height
//        }
//
//        return CGSize(width: resultWidth, height: resultHeight)
//    }
    
    private enum ActiveSheet {
       case camera, imageView
    }
}

//struct FloorPlanDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        FloorPlanDetailView(with: Image( "floorPlan"), viewModel: FloorPlanViewModel(installation: Installation()), index: 0)
//
//    }
//}
