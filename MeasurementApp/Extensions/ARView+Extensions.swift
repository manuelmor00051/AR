//
//  ARView+Extensions.swift
//  MeasurementApp
//
//  Created by Mohammad Azam on 5/17/22.
//

import Foundation
import ARKit
import RealityKit

extension ARSCNView {
    
    func addCoachingOverlay() {
        let coachingView = ARCoachingOverlayView()
        coachingView.goal = .horizontalPlane
        coachingView.session = self.session
        coachingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(coachingView)
    }
    
}
