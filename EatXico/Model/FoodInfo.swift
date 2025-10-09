//
//  FoofInfo.swift
//  EatXico
//
//  Created by Alan Cervantes on 04/10/25.
//

import Foundation

struct FoodInfo: Decodable {
    let nombre: String
    let ingredientes: [String]
}
