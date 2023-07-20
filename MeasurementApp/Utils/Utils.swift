//
//  Utils.swift
//  MeasurementApp
//
//  Created by manuel.moreno.local on 20/7/23.
//

import Foundation
import ARKit
import RealityKit

class Utils {
    static func getPoint(hitResult: ARRaycastResult) -> SCNNode {
        let cubeNode = SCNNode()
        let cubeGeometry = SCNBox(width: 0.01, height: 0.01, length: 0.01, chamferRadius: 0)
        cubeNode.geometry = cubeGeometry
        cubeNode.position = SCNVector3(hitResult.worldTransform.columns.3.x,
                                       hitResult.worldTransform.columns.3.y + 0.05,
                                       hitResult.worldTransform.columns.3.z)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        cubeNode.geometry?.firstMaterial = material
        
        return cubeNode
    }
    
    static func getLine(node1: SCNNode, node2: SCNNode) -> SCNNode {
        let lineGeometry = SCNGeometry.line(from: node1.position, to: node2.position)
        let lineNode = SCNNode(geometry: lineGeometry)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.green
        lineNode.geometry?.firstMaterial = material
        
        return lineNode
    }
    
    static func distanceCalculator(_ node1: SCNNode, _ node2: SCNNode) -> Float {
        let positionA = node1.worldPosition
        let positionB = node2.worldPosition
        
        let dx = positionB.x - positionA.x
        let dy = positionB.y - positionA.y
        let dz = positionB.z - positionA.z
        
        return sqrt(dx*dx + dy*dy + dz*dz)
    }
    
    static func midpointNodeBetweenNodes(_ node1: SCNNode, _ node2: SCNNode) -> SCNNode {
        let positionA = node1.position
        let positionB = node2.position

        let midX = (positionA.x + positionB.x) / 2
        let midY = (positionA.y + positionB.y) / 2
        let midZ = (positionA.z + positionB.z) / 2
        
        let midpoint = SCNVector3(x: midX, y: midY, z: midZ)

        let midpointNode = SCNNode()
        midpointNode.position = midpoint
        
        return midpointNode
    }
    
    static func getModel(modelName: String, scaleX: Float, scaleY: Float) -> SCNNode {
        let cramberryScene = SCNScene(named: modelName)
        guard let cramberryNode = cramberryScene?.rootNode.childNode(withName: "cramberryModel", recursively: true) else { fatalError("error descargando modelo") }
        cramberryNode.scale = SCNVector3(x: scaleX, y: scaleY, z: 0.01)
        
        let rotationAngle = Float(90.0) * .pi / 180
        let rotation = SCNAction.rotateBy(x: CGFloat(rotationAngle), y: 0.0, z: 0.0, duration: 0)
        cramberryNode.runAction(rotation)
        
        return cramberryNode
    }

    static func createArea(node1: SCNNode, node2: SCNNode, node3: SCNNode, node4: SCNNode) -> SCNNode {
        let minX = min(node1.position.x, node2.position.x, node3.position.x, node4.position.x)
        let maxX = max(node1.position.x, node2.position.x, node3.position.x, node4.position.x)
        let minY = min(node1.position.y, node2.position.y, node3.position.y, node4.position.y)
        let maxY = max(node1.position.y, node2.position.y, node3.position.y, node4.position.y)
        let minZ = min(node1.position.z, node2.position.z, node3.position.z, node4.position.z)
        let maxZ = max(node1.position.z, node2.position.z, node3.position.z, node4.position.z)

        let width = CGFloat(abs(maxX - minX))
        let height = CGFloat(0.03)
        let length = CGFloat(abs(maxZ - minZ))
        let position = SCNVector3(minX + Float(width / 2), minY + Float(height / 2), minZ + Float(length) / 2)

        let scnBox = SCNBox(width: width, height: height, length: length, chamferRadius: 0)

        let material = SCNMaterial()
        if let textureImage = UIImage(named: Constants.KitchenCounter.white) {
            material.diffuse.contents = textureImage
        } else {
            print("Error: No se pudo cargar la imagen.")
        }

        scnBox.materials = [material]

        let areaNode = SCNNode(geometry: scnBox)
        areaNode.position = position

        return areaNode
    }
}
