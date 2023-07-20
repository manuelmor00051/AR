//
//  Coordinator.swift
//  MeasurementApp
//
//  Created by Mohammad Azam on 5/17/22.
//

import Foundation
import SwiftUI
import ARKit

class Coordinator {

    var arView: ARSCNView?
    var startNode: SCNNode?
    var secondNode: SCNNode?
    var thirdNode: SCNNode?
    var endNode: SCNNode?

    lazy var measurementButton: UIButton = {
        let button = UIButton(configuration: .filled())
        button.setTitle("0.0 m^2", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        return button
    }()

    lazy var resetButton: UIButton = {

        let button = UIButton(configuration: .gray(), primaryAction: UIAction(handler: { [weak self] action in

            guard let arView = self?.arView else { return }
            self?.startNode = nil
            self?.secondNode = nil
            self?.thirdNode = nil
            self?.endNode = nil

            arView.scene.rootNode.enumerateChildNodes { (node, _) in
                node.removeFromParentNode()
            }
            self?.measurementButton.setTitle("0.00", for: .normal)

        }))



        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Reset", for: .normal)
        return button

    }()


    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {

        guard let arView = arView else { return }
        let tappedLocation = recognizer.location(in: arView)
        let query = arView.raycastQuery(from: tappedLocation, allowing: .existingPlaneGeometry, alignment: .horizontal)

        guard let finalQuery = query else { return }
        let results = arView.session.raycast(finalQuery)

        guard let hitResult = results.first else { return }

        if startNode == nil {
            let pointNode = Utils.getPoint(hitResult: hitResult)
            arView.scene.rootNode.addChildNode(pointNode)
            self.startNode = pointNode

        } else if secondNode == nil {
            let pointNode = Utils.getPoint(hitResult: hitResult)
            arView.scene.rootNode.addChildNode(pointNode)
            self.secondNode = pointNode

            guard let startNode = startNode,
                  let secondNode = secondNode
            else { return }

            let lineNode = Utils.getLine(node1: startNode, node2: secondNode)
            arView.scene.rootNode.addChildNode(lineNode)

        } else if thirdNode == nil {
            let pointNode = Utils.getPoint(hitResult: hitResult)
            arView.scene.rootNode.addChildNode(pointNode)
            self.thirdNode = pointNode

            guard let secondNode = secondNode,
                  let thirdNode = thirdNode
            else { return }

            let lineNode = Utils.getLine(node1: secondNode, node2: thirdNode)
            arView.scene.rootNode.addChildNode(lineNode)

        } else if endNode == nil {
            let pointNode = Utils.getPoint(hitResult: hitResult)
            arView.scene.rootNode.addChildNode(pointNode)
            self.endNode = pointNode

            guard let startNode = startNode,
                  let secondNode = secondNode,
                  let thirdNode = thirdNode,
                  let endNode = endNode
            else { return }

            let lineNode = Utils.getLine(node1: thirdNode, node2: endNode)
            let finalLineNode = Utils.getLine(node1: endNode, node2: startNode)
            arView.scene.rootNode.addChildNode(lineNode)
            arView.scene.rootNode.addChildNode(finalLineNode)

            /*let distance1 = Utils.distanceCalculator(startNode, secondNode)
            let distance2 = Utils.distanceCalculator(secondNode, thirdNode)
            let area = distance1 * distance2
            self.measurementButton.setTitle("\(String(format: "%.2f", area)) m^2", for: .normal)

            let model = Utils.getModel(modelName: Constants.Models3D.cramberry, scaleX: distance1 / 90, scaleY: distance2 / 60)
            model.position = Utils.midpointNodeBetweenNodes(startNode, thirdNode).position*/
            let area = Utils.createArea(node1: startNode, node2: secondNode, node3: thirdNode, node4: endNode)
            arView.scene.rootNode.addChildNode(area)
        }
    }

    func setupUI() {

        guard let arView = arView else { return }

        let stackView = UIStackView(arrangedSubviews: [measurementButton, resetButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        arView.addSubview(stackView)

        stackView.centerXAnchor.constraint(equalTo: arView.centerXAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: arView.bottomAnchor, constant: -60).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 44).isActive = true

    }
}
