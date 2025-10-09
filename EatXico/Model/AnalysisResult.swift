//
//  AnalysisResult.swift
//  Created for CameraViewModel and ResultView usage
//

import Foundation
import UIKit

struct AnalysisResult: Identifiable, Hashable {
    let id: UUID
    let dishName: String
    let capturedImage: UIImage
    let combinedIngredients: [String]
    
    init(dishName: String, capturedImage: UIImage, combinedIngredients: [String]) {
        self.id = UUID()
        self.dishName = dishName
        self.capturedImage = capturedImage
        self.combinedIngredients = combinedIngredients
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: AnalysisResult, rhs: AnalysisResult) -> Bool {
        lhs.id == rhs.id
    }
}
