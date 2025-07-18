//
//  NetworkError.swift
//  DragonBall_iOS_Avanzado
//
//  Created by Manuel Liebana Montoro on 18/7/25.
//

import Foundation

enum NetworkError: Error {
    case malformedURL
    case dataFormatting
    case other
    case noData
    case errorCode(Int?)
    case tokenFormatError
    case decoding
    
    var description: String {
        switch self {
        case .malformedURL:
            return "Error mal formed URL"
        case .dataFormatting:
            return "Error data formating"
        case .other:
            return "Error other"
        case .noData:
            return "Error no data"
        case .errorCode(let error):
            return "Error code \(error?.description ?? "Unknown")"
        case .tokenFormatError:
            return "Error token format"
        case .decoding:
            return "Error desconocido"
        }
    }
}

