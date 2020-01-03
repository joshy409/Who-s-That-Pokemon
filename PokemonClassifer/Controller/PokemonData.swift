//
//  PokemonInfo.swift
//  PokemonClassifer
//
//  Created by Joshua Yang on 1/2/20.
//  Copyright © 2020 Joshua Yang. All rights reserved.
//

import UIKit

class PokemonData {
    
    //let viewController = UIApplication.shared.windows.first!.rootViewController as! UINavigationController
    var delegate: PokemonDataDelegate?
    
    var flavorText : String = "" {
        didSet {
            self.delegate?.flavorTextDidChange(leftValue: flavorText)
        }
    }
    
    var types : [String] = [] {
        didSet {
            self.delegate?.typesDidChange(leftValue: types)
        }
    }
    
    func reset() {
        flavorText = ""
        types = []
    }
    
    static let pokeInfo = PokemonData()
}
