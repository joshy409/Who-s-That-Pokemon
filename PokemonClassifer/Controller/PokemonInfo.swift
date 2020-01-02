//
//  PokemonInfo.swift
//  PokemonClassifer
//
//  Created by Joshua Yang on 1/2/20.
//  Copyright © 2020 Joshua Yang. All rights reserved.
//

import UIKit

class PokemonInfo {
    
    //let viewController = UIApplication.shared.windows.first!.rootViewController as! UINavigationController
    
    var flavorText : String? = "" {
        didSet {
            ViewController().updateLabel()
        }
    }
    var types : [String] = [] {
        didSet {
            ViewController().updateLabel()
        }
    }
    
    static let pokeInfo = PokemonInfo()
}
