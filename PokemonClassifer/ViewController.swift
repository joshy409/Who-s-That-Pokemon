//
//  ViewController.swift
//  PokemonClassifer
//
//  Created by Joshua Yang on 12/26/19.
//  Copyright © 2019 Joshua Yang. All rights reserved.
//

import CoreML
import Vision
import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var flavorTextLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        navigationItem.title = "Who's that Pokemon!"
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let selectedImage = info[.originalImage] as? UIImage {

            guard let ciimage = CIImage(image: selectedImage) else {
                fatalError("failed to convert to CIIMage")
            }
            detect(image: ciimage)
            imageView.image = selectedImage
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: PokemonClassifier().model) else {
            fatalError("cannot load model")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let classification = request.results?.first as? VNClassificationObservation else {
                fatalError("could not classify image")
            }
            let classifiedPokemon = classification.identifier
            self.nameLabel.text = classifiedPokemon.capitalized
            self.getInfo(pokemon: classifiedPokemon.lowercased())
        }
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
    
    
    @IBAction func cameraPressed(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func getInfo(pokemon: String) {
        
        Alamofire.request("https://pokeapi.co/api/v2/pokemon-species/\(pokemon)").responseJSON { (response) in
            if response.result.isSuccess {
                //print(response)
                let pokemonJSON : JSON = JSON(response.result.value!)
                let flavorTexts = pokemonJSON["flavor_text_entries"][]
                self.getEnFlavorText(texts: flavorTexts)
            } else {
                print("request failed")
            }
        }
    }
    
    func getEnFlavorText(texts: JSON) {
        while true {
            let rand = Int.random(in: 0 ..< texts.count)
            if texts[rand]["language"]["name"] == "en" {
                print(rand)
                let flavorText = texts[rand]["flavor_text"].stringValue
                flavorTextLabel.text = flavorText.replacingOccurrences(of: "\n", with: " ")
                break
            }
        }
    }
}

