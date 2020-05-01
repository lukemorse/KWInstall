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
    var isComplete: Bool { self.pod.isComplete }
    @State private var position = CGSize.zero
    @State private var color = Color.red
    
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
            .frame(width: 40, height: 40)
            .position(pod.position)
            .colorMultiply(self.isComplete ? Color.green : Color.red)
//            .foregroundColor(isComplete ? Color.green : Color.red)
    }
    

}

let podImageDict: [PodType : String] = [
    .outdoor : "outdoor pod",
    .corner : "corner pod",
    .hallway : "hallway pod",
    .ceiling : "ceiling pod"
]

struct PodNodeView_Previews: PreviewProvider {
    static var previews: some View {
        PodNodeView(pod: Pod(podType: .ceiling, position: CGPoint(x: 100, y: 100)))
    }
}
