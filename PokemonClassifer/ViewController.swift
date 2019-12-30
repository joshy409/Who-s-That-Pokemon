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

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imagePicker.delegate = self
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
            self.navigationItem.title = classification.identifier.capitalized
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
}

