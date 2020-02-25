//
//  PokemonData.swift
//  PokemonClassifer
//
//  Created by Joshua Yang on 1/2/20.
//  Copyright © 2020 Joshua Yang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PokemonDataGrabber: ObservableObject {
    
    func updateInfo(pokemon: String) {
        AF.request("https://pokeapi.co/api/v2/pokemon-species/\(pokemon)").responseJSON { (response) in
        
            switch response.result {
            case .success(let value):
                let pokemonJSON : JSON = JSON(value)
                let flavorTexts = pokemonJSON["flavor_text_entries"][]
                self.getEnFlavorText(texts: flavorTexts)
            case .failure(_):
                print("request failed")
            }
        }
        
        AF.request("https://pokeapi.co/api/v2/pokemon/\(pokemon)").responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let pokemonJSON : JSON = JSON(value)
                let types = pokemonJSON["types"][]
                self.getTypes(pokemonTypes: types)
            case .failure(_):
                    print("request failed")
                }
        }
    }
    
    func getEnFlavorText(texts: JSON) {
        while true {
            let rand = Int.random(in: 0 ..< texts.count)
            if texts[rand]["language"]["name"] == "en" {
                let enFlavorText = texts[rand]["flavor_text"].stringValue
                    .replacingOccurrences(of: "\n", with: " ")
                    .replacingOccurrences(of: "\u{000C}", with: " ")
                PokemonData.pokeInfo.flavorText = enFlavorText
                break
            }
        }
    }
    
    func getTypes(pokemonTypes: JSON) {
        for n in 0..<pokemonTypes.count {
            PokemonData.pokeInfo.types.append(pokemonTypes[n]["type"]["name"].stringValue.capitalized)
        }
    }
}
