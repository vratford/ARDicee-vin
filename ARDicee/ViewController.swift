//
//  ViewController.swift
//  ARDicee
//
//  Created by Vincent Ratford on 4/27/18.
//  Copyright © 2018 Vincent Ratford. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    var diceArray = [SCNNode]()         // initialize to empty array

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]  // debug option to display feature points
        
        // Set the view's delegate
        sceneView.delegate = self
        
//        displayCube()
        
//        displayRedCube()
        
//        displaySpaceShip()
        
//        displayMoon()
        
//        displayEarth()
        
//        displayDice()
        
   
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
             // Create a session configuration
           
            let configuration = ARWorldTrackingConfiguration()
        
        guard ARWorldTrackingConfiguration.isSupported else {
            fatalError("AR only available on Iphone 7 or greater")
        }
        
        configuration.planeDetection = .horizontal
     
        // Run the view's session
        sceneView.session.run(configuration)
    
    }
        
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
        
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            if let hitResult = results.first {
              
                // Create a new scene
                let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
                
                if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
                    
                    diceNode.position = SCNVector3(
                        x: hitResult.worldTransform.columns.3.x,
                        y: hitResult.worldTransform.columns.3.y + diceNode.boundingSphere.radius * 3,
                        z: hitResult.worldTransform.columns.3.z)
                    
                    diceArray.append(diceNode)
                    
                    sceneView.scene.rootNode.addChildNode(diceNode)
                    
                    roll(dice: diceNode)
                }
                
            }
                
            }
            
        }
    
    func rollAll() {
        
        if !diceArray.isEmpty {         // !diceArray is not empty
            for dice in diceArray {
                roll(dice: dice)
            }
        }
    }
    
    func roll(dice: SCNNode) {
        
        let randomX = Float(arc4random_uniform(4)+1) * (Float.pi/2)
        
        let randomZ = Float(arc4random_uniform(4)+1) * (Float.pi/2)
        
        dice.runAction(SCNAction.rotateBy(
            x: CGFloat(randomX * 5),
            y: 0,
            z: CGFloat(randomZ * 5),
            duration: 0.5))
        
    }

    @IBAction func rollAgain(_ sender: UIBarButtonItem) {
        rollAll()
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        rollAll()
    }
    
    @IBAction func removeAllDice(_ sender: UIBarButtonItem) {
        
        if !diceArray.isEmpty {
            for dice in diceArray {
                dice.removeFromParentNode()
            }
            diceArray.removeAll()
        }
        
    }
    
    
    func renderer(_ renderer:SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
//            print("Plane detected")  // surface needs to be textured and not shiny
            
            let planeAnchor = anchor as! ARPlaneAnchor
            
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            let planeNode = SCNNode()
            
            planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
            
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            
            let gridMaterial = SCNMaterial()
            
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            
            plane.materials = [gridMaterial]
            
            planeNode.geometry = plane
            
            node.addChildNode(planeNode)
            
            
        } else {
            return
        }

    }

    func displayCube() {
  
        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01) // create geometry called cube
        
        // Change the color of each side
        
        let colors = [UIColor.green, // front
            UIColor.red, // right
            UIColor.blue, // back
            UIColor.yellow, // left
            UIColor.purple, // top
            UIColor.gray] // bottom
        
        let sideMaterials = colors.map { color -> SCNMaterial in
            let material = SCNMaterial()
            material.diffuse.contents = color
            material.locksAmbientWithDiffuse = true
            return material
        }
        
        cube.materials = sideMaterials
        
        //        let frontMaterial = sideMaterials[0]      // changes the front material to white
        //        frontMaterial.diffuse.contents = UIColor.white
        //
        
        let node = SCNNode() // point in 3d space
        
        node.position = SCNVector3(x: 0, y: 0, z: -0.5) // position of point
        
        node.geometry = cube // node has geometry of cube
        
        sceneView.scene.rootNode.addChildNode(node)  // place in sceneview
        
        sceneView.autoenablesDefaultLighting = true // adds light and shadows to cube
        
    }
    
    func displaySpaceShip() {
                // Create a new scene
                let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
                // Set the scene to the view
                sceneView.scene = scene
        
    }
    
    func displayRedCube() {
        
        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01) // create geometry called cube
        
        let material = SCNMaterial() // material is color red
        
        material.diffuse.contents = UIColor.red
        
        cube.materials = [material] // passing to array
        
        let node = SCNNode() // point in 3d space
        
        node.position = SCNVector3(x: 0, y: 0, z: -0.5) // position of point
        
        node.geometry = cube // node has geometry of cube
        
        sceneView.scene.rootNode.addChildNode(node)  // place in sceneview
        
        sceneView.autoenablesDefaultLighting = true // adds light and shadows to cube
        
    }
    
    func displayMoon() {
            
            let sphere = SCNSphere(radius: 0.2)
            
            let material = SCNMaterial() // material is color red
            
            material.diffuse.contents = UIImage(named: "art.scnassets/8k_moon.jpg")
            
            sphere.materials = [material] // passing to array
            
            let node = SCNNode() // point in 3d space
            
            node.position = SCNVector3(x: 0, y: 0, z: -0.5) // position of point
            
            node.geometry = sphere // node has geometry of sphere
            
            sceneView.scene.rootNode.addChildNode(node)  // place in sceneview
            
            sceneView.autoenablesDefaultLighting = true // adds light and shadows to sphere
            
        }
    
    func displayEarth() {
        
        let sphere = SCNSphere(radius: 0.15)
        
        let material = SCNMaterial() // material is color red
        
        material.diffuse.contents = UIImage(named: "art.scnassets/8k_earth_daymap.jpg")
        
        sphere.materials = [material] // passing to array
        
        let node = SCNNode() // point in 3d space
        
        node.position = SCNVector3(x: 0, y: 0, z: -0.5) // position of point
        
        node.geometry = sphere // node has geometry of sphere
        
        sceneView.scene.rootNode.addChildNode(node)  // place in sceneview
        
        sceneView.autoenablesDefaultLighting = true // adds light and shadows to sphere
        
    }

    func displayDice() {
        
        // Create a new scene
        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
        
        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
        
        diceNode.position = SCNVector3(x: 0, y: 0, z: -0.1)
        
        sceneView.scene.rootNode.addChildNode(diceNode)
         
        }
        
    }

}
