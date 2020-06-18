//
//  Installation.swift
//  KW Install
//
//  Created by Luke Morse on 4/6/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CodableFirebase

struct Installation: Encodable, Identifiable, Hashable  {
    static func == (lhs: Installation, rhs: Installation) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: Int {hashValue}
    let installationID: String
    var team: Team
    var status: InstallationStatus
    var schoolType: SchoolType
    var address: String
    var districtContact: String
    var districtName: String
    var districtID: String
    var schoolContact: String
    var schoolName: String
    var email: String
    var numFloors: Int
    var numRooms: Int
    var numPods: Int
    var date: Date
    var floorPlanUrls: [String]
    
    init(districtID: String) {
        self.installationID = UUID().uuidString
        self.status = .notStarted
        self.team = Team()
        self.schoolType = .elementary
        self.address = ""
        self.districtContact = ""
        self.districtName = ""
        self.districtID = districtID
        self.schoolContact = ""
        self.schoolName = ""
        self.email = ""
        self.numFloors = 0
        self.numRooms = 0
        self.numPods = 0
        self.date = Date()
        self.floorPlanUrls = []
    }
    
    private enum CodingKeys: String, CodingKey {
        
        case installationID
        case status
        case team
        case schoolType
        case address
        case districtContact
        case districtName
        case districtID
        case schoolContact
        case schoolName
        case email
        case numFloors
        case numRooms
        case numPods
        case date
        case floorPlanURLs
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(installationID, forKey: .installationID)
        try container.encode(team, forKey: .team)
        try container.encode(status, forKey: .status)
        try container.encode(schoolType.description, forKey: .schoolType)
        try container.encode(address, forKey: .address)
        try container.encode(districtContact, forKey: .districtContact)
        try container.encode(districtName, forKey: .districtName)
        try container.encode(districtID, forKey: .districtID)
        try container.encode(schoolContact, forKey: .schoolContact)
        try container.encode(schoolName, forKey: .schoolName)
        try container.encode(email, forKey: .email)
        try container.encode(numFloors, forKey: .numFloors)
        try container.encode(numRooms, forKey: .numRooms)
        try container.encode(numPods, forKey: .numPods)
        try container.encode(Timestamp(date: date), forKey: .date)
        try container.encode(floorPlanUrls, forKey: .floorPlanURLs)
    }
}

extension Installation: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        installationID = try container.decode(String.self, forKey: .installationID)
        status = try container.decode(InstallationStatus.self, forKey: .status)
        team = try container.decode(Team.self, forKey: .team)
        address = try container.decode(String.self, forKey: .address)
        districtContact = try container.decode(String.self, forKey: .districtContact)
        districtName = try container.decode(String.self, forKey: .districtName)
        districtID = try container.decode(String.self, forKey: .districtID)
        schoolContact = try container.decode(String.self, forKey: .schoolContact)
        schoolName = try container.decode(String.self, forKey: .schoolName)
        email = try container.decode(String.self, forKey: .email)
        numFloors = try container.decode(Int.self, forKey: .numFloors)
        numRooms = try container.decode(Int.self, forKey: .numRooms)
        numPods = try container.decode(Int.self, forKey: .numPods)
        floorPlanUrls = try container.decode([String].self, forKey: .floorPlanURLs)
        
        let timeStamp: Timestamp = try container.decode(Timestamp.self, forKey: .date)
        date = timeStamp.dateValue()
        
        if let schoolTypeValue = try? container.decode(Int.self, forKey: .schoolType) {
            schoolType = SchoolType(rawValue: schoolTypeValue) ?? SchoolType.unknown
        } else {
            schoolType = .unknown
        }
    }
}

enum InstallationStatus: Int, Codable, CaseIterable, Hashable, Identifiable {
    var id: Int { hashValue }
    
    case notStarted
    case inProgress
    case complete
    
    var description: String {
        switch self {
        case .notStarted: return "Not Started"
        case .inProgress: return "In Progress"
        case .complete: return "Complete"
        }
    }
}
