//
//  User.swift
//  KW Install
//
//  Created by Luke Morse on 4/7/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase

struct User: Encodable {
    let name: String
    let team: DocumentReference
    let email: String
    
    private enum CodingKeys: String, CodingKey {
        case name
        case team
        case email
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(team, forKey: .team)
        try container.encode(email, forKey: .email)
    }
}

extension User: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        team = try container.decode(DocumentReference.self, forKey: .team)
        email = try container.decode(String.self, forKey: .email)
    }
}
