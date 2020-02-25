//
//  PokemonInfo.swift
//  PokemonClassifer
//
//  Created by Joshua Yang on 1/2/20.
//  Copyright © 2020 Joshua Yang. All rights reserved.
//

import UIKit

class PokemonData {

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
    
    var name: String = ""
    
    func reset() {
        flavorText = ""
        types = []
        name = ""
    }
    
    static let pokeInfo = PokemonData()
}
