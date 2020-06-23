//
//  PodNodeView.swift
//  KW Sales
//
//  Created by Luke Morse on 4/16/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import SwiftUI

struct PodNodeView: Identifiable, Hashable, Equatable, View {
    
    let pod: Pod
    var id: Int { hashValue }
    @State private var position = CGSize.zero
    
    static func == (lhs: PodNodeView, rhs: PodNodeView) -> Bool {
        return lhs.pod == rhs.pod
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(pod)
    }
    
    var body: some View {
        Image(podImageDict[pod.podType] ?? "")
            .resizable()
            .scaledToFit()
            .frame(
                width: pod.podType == .horizontal_hallway ? 7.5 : 5,
                height: pod.podType == .vertical_hallway ? 7.5 : 5)
            .colorMultiply(pod.imageUrl == nil ? Color.red : Color.green)
    }
    

}

let podImageDict: [PodType : String] = [
    .outdoor : "outdoor pod",
    .corner : "corner pod",
    .horizontal_hallway : "horizontal hallway pod",
    .vertical_hallway : "vertical hallway pod"
]

struct PodNodeView_Previews: PreviewProvider {
    static var previews: some View {
        PodNodeView(pod: Pod(podType: .vertical_hallway, xMul: 0.5, yMul: 0.5))
    }
}
