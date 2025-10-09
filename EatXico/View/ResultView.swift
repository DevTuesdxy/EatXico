//
//  ResultView.swift
//  EatXico
//
//  Created by Alan Cervantes on 04/10/25.
//

import SwiftUI

struct ResultView: View {
    let result: AnalysisResult
    
    var body: some View {
        List {
            Section {
                Image(uiImage: result.capturedImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .listRowInsets(EdgeInsets()) // Para que la imagen ocupe todo el ancho
            }
            
            Section(header: Text("Ingredientes").font(.headline)) {
                // Lista de ingredientes combinados
                ForEach(result.combinedIngredients, id: \.self) { ingredient in
                    Text(ingredient)
                }
            }
        }
        .navigationTitle(result.dishName)
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationView {
        ResultView(result: AnalysisResult(
            dishName: "Tacos al Pastor",
            capturedImage: UIImage(systemName: "photo.fill")!,
            combinedIngredients: ["Carne de cerdo", "Cebolla", "Cilantro", "Piña", "Tortilla de maíz"]
        ))
    }
}
