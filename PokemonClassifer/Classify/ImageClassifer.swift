//
//  ImageClassifer.swift
//  PokemonClassifer
//
//  Created by Joshua Yang on 2/25/20.
//  Copyright © 2020 Joshua Yang. All rights reserved.
//

import CoreML
import Vision
import UIKit

class ImageClassifier {
    
    static func detect(image: CIImage) -> String {
        var classifiedPokemon : String = ""
        
        guard let model = try? VNCoreMLModel(for: PokemonClassifier().model) else {
            fatalError("cannot load model")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let classification = request.results?.first as? VNClassificationObservation else {
                fatalError("could not classify image")
            }
            // if classification is successful
            classifiedPokemon = classification.identifier
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
        
        return classifiedPokemon;
        
    }
    
}
