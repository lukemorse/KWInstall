//
//  Constants.swift
//  KW Install
//
//  Created by Luke Morse on 4/2/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import Foundation
import FirebaseFirestore
import UIKit

struct Constants {
    
    struct TabBarImageName {
        static let tabBar0 = "calendar.circle.fill"
        static let tabBar1 = "person.3.fill"
        static let tabBar2 = "checkmark.circle.fill"
        static let tabBar3 = "ellipsis.circle.fill"
    }
    
    struct TabBarText {
        static let tabBar0 = "Calendar"
        static let tabBar1 = "Team"
        static let tabBar2 = "Completed"
        static let tabBar3 = "References"
    }
    
    static let kLogInDataCollection = "installLogInData"
    
    static let kFloorPlanFolder = "floorPlansFolder"
    static let kPodImageFolder = "podImages"
    
    static let kDistrictCollection = "districts"
    static let kTeamCollection = "teams"
    static let kInstallationCollection = "installs"
    static let kFloorPlanCollection = "floorPlansCollection"
    static let kPodSubCollection = "pods"
    static let kSalesUserCollection = "salesUsers"
    static let kInstallationUserCollection = "installationUsers"
    
    static let kMasterAccountName = "brigittec"
}
