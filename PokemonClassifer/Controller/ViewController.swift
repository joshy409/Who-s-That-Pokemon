//
//  ViewController.swift
//  PokemonClassifer
//
//  Created by Joshua Yang on 12/26/19.
//  Copyright © 2019 Joshua Yang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var flavorTextLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!

    var pokemonDataGrabbber = PokemonDataGrabber()
    var showOriginal: Bool = false
    
    var originalImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        navigationItem.title = "Who's that Pokemon!"
        PokemonData.pokeInfo.delegate = self
        flavorTextLabel.text = "Show me a picture and\n I'll tell you which Pokemon it is!"
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.imageTapped(_:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        self.imageView.addGestureRecognizer(tap)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            originalImage = selectedImage
            PokemonData.pokeInfo.reset()
            
            guard let ciimage = CIImage(image: selectedImage) else {
                fatalError("failed to convert to CIIMage")
            }
            

            let classifiedPokemon = ImageClassifier.detect(image: ciimage)
            self.nameLabel.text = "\(classifiedPokemon.capitalized)"
            PokemonData.pokeInfo.name = classifiedPokemon.capitalized
            self.pokemonDataGrabbber.updateInfo(pokemon: classifiedPokemon.lowercased())

            imageView.image = selectedImage
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraPressed(_ sender: UIBarButtonItem) {
         imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func photoPressed(_ sender: UIBarButtonItem) {
         imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        if PokemonData.pokeInfo.name.lowercased() != "" {
            if sender.state == .ended {
                if showOriginal == true {
                    imageView.image = originalImage
                    showOriginal = !showOriginal
                } else {
                    imageView.image = UIImage(named: "PokeDex/\(PokemonData.pokeInfo.name.lowercased()).jpeg")
                    showOriginal = !showOriginal
                }
            }
        }
    }
}

//MARK: - PokemonInfoDelegate

extension ViewController: PokemonDataDelegate {
    
    func typesDidChange(leftValue: [String]) {
        let fullString = NSMutableAttributedString(string: "")
        
        for type in leftValue {
             // create our NSTextAttachment
            let image1Attachment = NSTextAttachment()
            image1Attachment.image = UIImage(named: "\(type)")
            image1Attachment.bounds = CGRect(x: 0, y: -8, width: 25, height: 25)

            // wrap the attachment in its own attributed string so we can append it
            let image1String = NSAttributedString(attachment: image1Attachment)

             // add the NSTextAttachment wrapper to our full string, then add some more text.

             fullString.append(image1String)
             fullString.append(NSAttributedString(string: " \(type) " ))
        }
        
        // draw the result in a label
        typeLabel.attributedText = fullString
    }
    
    func flavorTextDidChange(leftValue: String) {
        flavorTextLabel.text = PokemonData.pokeInfo.flavorText
        //flavorTextLabel.sizeToFit()
    }
}

