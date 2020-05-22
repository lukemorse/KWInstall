//
//  Pod.swift
//  KW Sales
//
//  Created by Luke Morse on 4/29/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase

struct Pod: Encodable, Hashable, Identifiable {
    var id: Int { hashValue }
    let podType: PodType
    var position: CGPoint
    var isComplete = false
    var imageUrl: String?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(podType)
        hasher.combine(position.x)
        hasher.combine(position.y)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case podType
        case position
        case isComplete
        case imageUrl
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(podType, forKey: .podType)
        try container.encode(position, forKey: .position)
        try container.encode(isComplete, forKey: .isComplete)
        try container.encode(imageUrl, forKey: .imageUrl)
    }
}

extension Pod: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        podType = try container.decode(PodType.self, forKey: .podType)
        position = try container.decode(CGPoint.self, forKey: .position)
        isComplete = try container.decode(Bool.self, forKey: .isComplete)
//        imageUrl = try container.decode(String.self, forKey: .imageUrl)
        
        if container.contains(.imageUrl) {
            self.imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
        } else {
            self.imageUrl = nil
        }
    }
}

enum PodType: Int, Codable, CaseIterable, Hashable, Identifiable {
    var id: Int { hashValue }
    
    case outdoor, corner, horizontal_hallway, vertical_hallway
    
    var description: String {
        switch self {
        case .outdoor:
            return "outdoor"
        case .corner:
            return "corner"
        case .horizontal_hallway:
            return "hallway"
        case .vertical_hallway:
            return "vertical hallway"
        }
    }
}
