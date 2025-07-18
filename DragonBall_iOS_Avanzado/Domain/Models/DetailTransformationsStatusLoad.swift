//
//  DetailTransformationsStatusLoad.swift
//  DragonBall_iOS_Avanzado
//
//  Created by Manuel Liebana Montoro on 18/7/25.
//

import Foundation

enum DetailTransformationsStatusLoad {
    case loading(_ isLoading: Bool)
    case loaded
    case errorNetwork(_error: String)
}
