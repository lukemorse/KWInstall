//
//  Constants.swift
//  KW Install
//
//  Created by Luke Morse on 4/2/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import Foundation
import Firebase
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
    
    static let kFloorPlanCollection = "floorPlansCollection"
    static let kFloorPlanFolder = "floorPlansFolder"
    static let kPodImageFolder = "podImages"
    static let kDistrictCollection = "districts"
    static let kTeamCollection = "teams"
    static let kImplementationPlanCollection = "implementationPlans"
    
    static let chicagoGeoPoint = GeoPoint(latitude: 41.8781, longitude: -87.6298)
    
    static var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    static var rowHeight: Int { idiom == UIUserInterfaceIdiom.phone ? 10 : 20}
}



