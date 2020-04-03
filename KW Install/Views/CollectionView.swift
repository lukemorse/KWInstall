//
//  CollectionView.swift
//  KW Install
//
//  Created by Luke Morse on 4/3/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI
import UIKit

struct CollectionView: UIViewRepresentable {
    func makeUIView(context: Context) -> UICollectionView {
        UICollectionView(frame: .zero)
    }
    
    func updateUIView(_ uiView: UICollectionView, context: Context) {
        
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView()
    }
    
}

