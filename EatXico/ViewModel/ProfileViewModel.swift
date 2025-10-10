//
//  ProfileViewModel.swift
//  EatXico
//
//  Created by Alan Cervantes on 09/10/25.
//

import Foundation
import SwiftUI
import Combine

final class ProfileViewModel: ObservableObject {
    @Published var userProfile: UserProfile
    
    private let fileURL: URL
    
    init() {
            // Obtenemos la URL del directorio de documentos de la app
        do {
            let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            self.fileURL = documentsDirectory.appendingPathComponent("userProfile.json")
        } catch {
            fatalError("Error Crítico: No se pudo acceder al directorio de documentos. \(error)")
        }
        self.userProfile = Self.loadProfile(from: fileURL)
    }
    
    private static func loadProfile(from url: URL) -> UserProfile {
        guard let data = try? Data(contentsOf: url) else {
            print("No se encontro archivo de perfil")
            return UserProfile.empty
        }
        do{
            let decoder = JSONDecoder()
            print("Perfil Cargado con exito")
            return try decoder.decode(UserProfile.self, from: data)
        } catch{
            print("Error al decodificar el perfil: \(error)")
            return UserProfile.empty
        }
    }
    
    func saveProfile() {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(userProfile)
            try data.write(to: fileURL, options: .atomicWrite)
            print("Perfil guardado exitosamente en: \(fileURL.path)")
        } catch {
            print("Error al guardar el perfil: \(error)")
        }
    }
    
}
