//
//  Hero.swift
//  DragonBall_iOS_Avanzado
//
//  Created by Manuel Liebana Montoro on 18/7/25.
//

import Foundation

// MARK: - Hero
struct Hero: Decodable, Hashable {
    let id: String
    let name: String?
    let photo: String?
    let description: String?
}
