//
//  PokemonInfoDelegate.swift
//  PokemonClassifer
//
//  Created by Joshua Yang on 1/2/20.
//  Copyright © 2020 Joshua Yang. All rights reserved.
//

import UIKit

protocol PokemonDataDelegate: class {
    func flavorTextDidChange(leftValue: String)
    func typesDidChange(leftValue: [String])
}
