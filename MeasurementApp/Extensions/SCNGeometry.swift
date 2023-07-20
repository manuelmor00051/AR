//
//  SCNGeometry.swift
//  MeasurementApp
//
//  Created by manuel.moreno.local on 20/7/23.
//

import Foundation
import ARKit

extension SCNGeometry {
    static func line(from start: SCNVector3, to end: SCNVector3) -> SCNGeometry {
        let sources = SCNGeometrySource(vertices: [start, end])
        let indices: [UInt32] = [0, 1]
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)

        let lineGeometry = SCNGeometry(sources: [sources], elements: [element])
        return lineGeometry
    }

    static func polygon(points: [SCNVector3]) -> SCNGeometry {
            let source = SCNGeometrySource(vertices: points)
            let indices: [UInt32] = [0, 1, 2, 2, 3, 0]
            let element = SCNGeometryElement(indices: indices, primitiveType: .triangles)
            return SCNGeometry(sources: [source], elements: [element])
        }
}
