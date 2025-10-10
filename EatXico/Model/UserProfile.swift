//
//  UserProfile.swift
//  EatXico
//
//  Created by Alan Cervantes on 09/10/25.
//

import Foundation

struct UserProfile: Codable {
    var nombre: String
    var edad: String
    var alergias: String
    static let empty = UserProfile(nombre: "", edad: "", alergias: "")
}
