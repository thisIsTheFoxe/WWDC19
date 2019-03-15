//
//  ARTestView.swift
//  Book_Sources
//
//  Created by Henrik Storch on 09.03.19.
//

import UIKit
import ARKit

class ARGameView: ARSCNView {
    
    var playing = false
    var label: UILabel!
    
    override init(frame: CGRect, options: [String : Any]? = nil) {
        super.init(frame: frame, options: options)
        let sessionConfig = ARWorldTrackingConfiguration()
        sessionConfig.planeDetection = [.horizontal]
        self.session.run(sessionConfig)
        self.debugOptions = [.showWireframe, .showBoundingBoxes, .showPhysicsShapes, .showFeaturePoints]
        self.showsStatistics = true
        self.allowsCameraControl = true
        self.scene = SCNScene()
        self.delegate = self
        self.session.delegate = self
        self.autoenablesDefaultLighting = true
        
        label = UILabel(frame: CGRect(x: 100, y: 100, width: 500, height: 77))
        self.addSubview(label)
        
        label.text = "Dummy"
        
        
        let newCube = SCNBox(width: 10, height: 10, length: 10, chamferRadius: 0)
        let cubeNode = SCNNode(geometry: newCube)
        cubeNode.position.y += 1
        scene.rootNode.addChildNode(cubeNode)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

extension ARGameView: ARSessionDelegate{
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        guard let anch = anchors.first else {
            return
        }
        DispatchQueue.main.async {
            //contains ARPlaneAncors
            self.label.text = "updateNode for: ARANCHOR=\(anch.classForCoder.description())"
        }
    }
    
    
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if #available(iOS 12.0, *) {
            if frame.worldMappingStatus == .mapped {
                DispatchQueue.main.async {
                    self.label.backgroundColor = .green
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

extension ARGameView: ARSCNViewDelegate{
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        DispatchQueue.main.async {
            switch camera.trackingState {
            case .limited(_):
                self.label.backgroundColor = .red
            case .normal:
                self.label.backgroundColor = .white
            default:
                return
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willUpdate node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            self.label.text = "updateNode for: ARANCHOR=\(anchor.isMember(of: ARPlaneAnchor.self))"
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            self.label.text = "addNode for: ARANCHOR=\(anchor.isMember(of: ARPlaneAnchor.self))"

        }
        guard !playing, let anchor = anchor as? ARPlaneAnchor else { return }
        playing = true
        let newCube = SCNBox(width: 10, height: 10, length: 10, chamferRadius: 0)
        let cubeNode = SCNNode(geometry: newCube)
        cubeNode.position.y += 1
        node.addChildNode(cubeNode)
        
        var i = -6.0
        for emoji in StackEmoji.allCommandEmoji {
            let card = EmojiCard(emojiChar: emoji)
            card.position.x = Float(0.075 * i)
            self.scene.rootNode.addChildNode(card)
            i += 1
        }
    }
}
