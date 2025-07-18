//
//  Transformation.swift
//  DragonBall_iOS_Avanzado
//
//  Created by Manuel Liebana Montoro on 18/7/25.
//

import Foundation

// MARK: - ModelTransformation
struct Transformation: Decodable {
    let photo: String?
    let hero: Hero?
    let id, name, description: String?
}
