//
//  LaunchLogo.swift
//  KW Install
//
//  Created by Luke Morse on 4/10/20.
//  Copyright © 2020 Luke Morse. All rights reserved.
//

import UIKit
import SpriteKit

class LaunchLogo: UIView {

    override func didMoveToWindow() {
        rotate()
        print("rotating")
    }
    
    

}

extension UIView{
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = Double.pi * 2
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
}
