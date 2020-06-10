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
        Image(podImageDict[self.pod.podType] ?? "")
            .resizable()
            .scaledToFit()
            .frame(
                width: self.pod.podType == .horizontal_hallway ? 7.5 : 5,
                height: self.pod.podType == .vertical_hallway ? 7.5 : 5)
            .position(pod.position)
            .colorMultiply(self.pod.isComplete ? Color.green : Color.red)
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
        PodNodeView(pod: Pod(podType: .vertical_hallway, position: CGPoint(x: 100, y: 100)))
    }
}
