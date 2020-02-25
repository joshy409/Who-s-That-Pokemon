//
//  ARViewController.swift
//  PokemonClassifer
//
//  Created by Joshua Yang on 2/24/20.
//  Copyright © 2020 Joshua Yang. All rights reserved.
//

import UIKit
import ARKit
import SceneKit


class ARViewController: UIViewController, ARSCNViewDelegate {
    
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    let pokemon = SCNNode()
    
    var rootNode: SCNNode {
        return sceneView.scene.rootNode
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        
        pokemon.addChildNode(loadModel(named: "pokemon"))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARFaceTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARFaceAnchor else {return}
        
        node.addChildNode(pokemon)
        pokemon.childNodes[0].geometry?.firstMaterial?.diffuse.contents = UIColor.green
        randomPokemonImage()
        
    }
    
 
    
    func loadModel(named modelName: String) -> SCNNode {
        let sceneReference = Bundle.main.url(forResource: modelName, withExtension: "scn", subdirectory: "art.scnassets")!
        let refNode = SCNReferenceNode(url: sceneReference)!
        refNode.load()
        refNode.name = modelName
        return refNode
    }
    
    
    func randomPokemonImage() {
        // Get the document directory url
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil)
            print(directoryContents)

        } catch {
            print(error)
        }
    }
}
