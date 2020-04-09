//
//  Team.swift
//  KW Install
//
//  Created by Luke Morse on 4/7/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase

struct Team: Encodable {
    let name: String
    let leader: String
    let members: [String]
    var installations: [DocumentReference]
    
    private enum CodingKeys: String, CodingKey {
        case name
        case leader
        case members
        case installations
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(leader, forKey: .leader)
        try container.encode(members, forKey: .members)
        try container.encode(installations, forKey: .installations)
    }
    
}

extension Team: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        leader = try container.decode(String.self, forKey: .leader)
        members = try container.decode([String].self, forKey: .members)
        installations = try container.decode([DocumentReference].self, forKey: .installations)
    }
}
