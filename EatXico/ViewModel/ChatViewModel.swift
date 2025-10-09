//
//  ChatViewModel.swift
//  EatXico
//
//  Created by Alan Cervantes on 02/10/25.
//

import Foundation
import Combine
import FoundationModels

@MainActor
final class ChatViewModel: ObservableObject {
    struct Msg: Identifiable, Equatable {
        let id: UUID
        let role: Role
        let text: String
        enum Role { case system, user, assistant }
        
        init(id: UUID = UUID(), role: Role, text: String) {
            self.id = id
            self.role = role
            self.text = text
        }
    }
    
    @Published var msgs: [Msg] = []
    @Published var input: String = ""
    @Published var thinking = false
    @Published var error: String?
    
    private var session: LanguageModelSession?
    
    var maxTokens: Int = 220
    var temperature: Double = 0.7
    
    func getInfo(for name: String) async throws -> FoodInfo {
        if session == nil {
            session = LanguageModelSession(instructions: buildSystemPrompt())
        }
        let prompt = "Dame la receta o información para: \(name). Responde solo con JSON válido."
        let options = GenerationOptions(temperature: temperature)
        let response = try await session!.respond(to: prompt, options: options)
        let text = response.content
        let decoder = JSONDecoder()
        // Intento directo
        if let data = text.data(using: .utf8) {
            if let info = try? decoder.decode(FoodInfo.self, from: data) {
                return info
            }
        }
        // Heurística: extraer el primer bloque JSON
        if let start = text.firstIndex(of: "{"), let end = text.lastIndex(of: "}") {
            let jsonSubstring = text[start...end]
            if let data = String(jsonSubstring).data(using: .utf8) {
                if let info = try? decoder.decode(FoodInfo.self, from: data) {
                    return info
                }
            }
        }
        throw NSError(domain: "ChatViewModel", code: -1, userInfo: [NSLocalizedDescriptionKey: "No se pudo decodificar la respuesta del modelo como FoodInfo. Respuesta: \(text)"])
    }
    
    func send() async {
        let q = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return }
        input = ""
        
        msgs.append(.init(role: .user, text: q))
        
        thinking = true; defer { thinking = false }
        do {
            if session == nil {
                session = LanguageModelSession(instructions: buildSystemPrompt())
            }
            
            msgs.append(.init(role: .assistant, text: ""))
            let idx = msgs.count - 1
            
            let options = GenerationOptions(
                temperature: temperature
            )

            let response = try await session!.respond(to: q, options: options)
            
            let current = msgs[idx]
            msgs[idx] = .init(id: current.id, role: .assistant, text: response.content)
            
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    private func buildSystemPrompt() -> String {
        return """
        Eres un asistente experto en gastronomía. Responde únicamente con un objeto JSON. No uses asteriscos ni texto introductorio.

        El JSON debe tener la siguiente estructura:
        {
          "nombre": "Nombre del Platillo",
          "ingredientes": ["Ingrediente 1", "Ingrediente 2"],
          "preparacion": ["Paso 1", "Paso 2"],
          "descripcion": "Descripción del ingrediente o platillo",
          "usos_comunes": ["Uso 1", "Uso 2"]
        }
        
        Si la petición es sobre un platillo completo, llena las claves "nombre", "ingredientes" y "preparacion".
        Si es sobre un ingrediente, llena "nombre", "descripcion" y "usos_comunes".

        ---
        EJEMPLO 1:
        Petición del usuario: "Barbacoa"
        Tu respuesta:
        {
          "nombre": "Barbacoa",
          "ingredientes": [
            "Carne de res (chuck o brisket)",
            "Cebolla y ajo",
            "Chiles secos (ancho, guajillo)",
            "Hojas de aguacate",
            "Sal y especias"
          ],
          "preparacion": [
            "Adobo: Licuar los chiles hidratados con ajo, cebolla y especias.",
            "Marinar: Cubrir la carne con el adobo por varias horas.",
            "Cocción: Envolver la carne en hojas de plátano y cocinarla lentamente.",
            "Servir: Deshebrar la carne y servirla en tacos."
          ]
        }
        ---
        EJEMPLO 2:
        Petición del usuario: "Cilantro"
        Tu respuesta:
        {
          "nombre": "Cilantro",
          "descripcion": "Hierba aromática fundamental en la cocina mexicana, de sabor fresco y cítrico.",
          "usos_comunes": [
            "Toque final en tacos y caldos.",
            "Ingrediente clave en salsas como guacamole y salsa verde."
          ]
        }
        """
    }
}
