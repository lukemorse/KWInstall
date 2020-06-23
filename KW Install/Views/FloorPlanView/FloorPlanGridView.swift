//
//  FloorPlanGridView.swift
//  KW Install
//
//  Created by Luke Morse on 4/3/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//


import SwiftUI

struct FloorPlanGridView: View {
    let installID: String
    let urls: [URL]
    @Environment(\.imageCache) var cache: ImageCache
    @State var selection: Int?
    @State var pushDetailView = false
    @State var isLoading = false
    
    var body : some View {
        let urlArray = urls.chunked(into: 3)
        return VStack {
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: true) {
                    VStack {
                        // create number of rows
                        ForEach(0..<urlArray.count, id: \.self) { row in
                            HStack {
                                // create 2 columns
                                ForEach(0..<urlArray[row].count, id: \.self) { column in
                                    self.getNavLink(index: row * 2 + column, size: geometry.size)
                                }
                            }.padding()
                        }
                    }
                }
                .frame(width: geometry.size.width)
            }
            .frame(height: 300)
            .padding()
        }
        .onAppear() {
            self.selection = nil
        }
    }
    
    func getNavLink(index: Int, size: CGSize) -> some View {
        let asyncImage = AsyncImage(url: urls[index], cache: self.cache, placeholder: Text("Loading...").padding(), configuration:
        {$0.resizable()})
        
        return NavigationLink(destination: FloorPlanDetailView(with: FloorPlanViewModel(url: urls[index], installID: self.installID, floorNumString: String(index))), tag: index, selection: $selection) {
            asyncImage
                .aspectRatio(contentMode: .fit)
                .border(Color.black)
                .frame(width: size.width / 2.5)
                .onTapGesture {
                    self.selection = index
            }
        }
        .buttonStyle(PlainButtonStyle())
        .inExpandingRectangle()
    }
    
}



//struct FloorPlanGridView_Previews: PreviewProvider {
//    static var previews: some View {
//        FloorPlanGridView( viewModel: FloorPlanViewModel(installation: Installation()))
//    }
//}

