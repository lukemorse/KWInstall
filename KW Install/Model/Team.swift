//
//  Team.swift
//  KW Install
//
//  Created by Luke Morse on 4/7/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CodableFirebase

struct Team: Encodable, Hashable, Identifiable {
    var id: Int { hashValue }
    
    let name: String
    let leader: User
    let members: [User]
    var installations: [Date: [String:String]]
    var completedInstallations: [String:String]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(leader)
        hasher.combine(members)
        hasher.combine(installations)
    }
    
    init(name: String = "",
         leader: User = User(uid: "", name: "", email: "", phone: ""),
         members: [User] = [],
         installations: [Date: [String:String]] = [:],
         completedInstallations: [String:String]) {
        self.name = name
        self.leader = leader
        self.members = members
        self.installations = installations
        self.completedInstallations = completedInstallations
    }
    
    private enum CodingKeys: String, CodingKey {
        case name, leader, members, installations, completedInstallations
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(leader, forKey: .leader)
        try container.encode(members, forKey: .members)
        try container.encode(installations, forKey: .installations)
        try container.encode(completedInstallations, forKey: .completedInstallations)
    }
}

extension Team: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        leader = try container.decode(User.self, forKey: .leader)
        members = try container.decode([User].self, forKey: .members)
        installations = try container.decode([Date: [String:String]].self, forKey: .installations)
        completedInstallations = try container.decode([String:String].self, forKey: .completedInstallations)
    }
}
