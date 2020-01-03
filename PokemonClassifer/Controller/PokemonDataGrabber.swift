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
        
        Alamofire.request("https://pokeapi.co/api/v2/pokemon/\(pokemon)").responseJSON { (response) in
            if response.result.isSuccess {
                let pokemonJSON : JSON = JSON(response.result.value!)
                let types = pokemonJSON["types"][]
                self.getTypes(pokemonTypes: types)
            } else {
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
