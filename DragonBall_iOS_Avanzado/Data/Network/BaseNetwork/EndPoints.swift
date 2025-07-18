//
//  EndPoints.swift
//  DragonBall_iOS_Avanzado
//
//  Created by Manuel Liebana Montoro on 18/7/25.
//

import Foundation

enum EndPoints {
    case login
    case heroes
    case transformations
    case locations
    
    func endpoint() -> String {
        switch self {
        case .login:
            return "/api/auth/login"
        case .heroes:
            return "/api/heros/all"
        case .transformations:
            return "/api/heros/tranformations"
        case .locations:
            return "/api/heros/locations"
        }
    }
}
