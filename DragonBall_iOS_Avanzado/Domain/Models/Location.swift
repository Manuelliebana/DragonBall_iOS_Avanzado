//
//  Location.swift
//  DragonBall_iOS_Avanzado
//
//  Created by Manuel Liebana Montoro on 18/7/25.
//

import Foundation

struct Location: Decodable {

    let id: String?
    let latitude: String?
    let longitude: String?
    let date: String?
    let hero: Hero?
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case latitude = "latitud"
        case longitude = "longitud"
        case date = "dateShow"
        case hero
    }
}
