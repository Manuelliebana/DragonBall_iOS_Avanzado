//
//  DetailTransformationsViewModel.swift
//  DragonBall_iOS_Avanzado
//
//  Created by Manuel Liebana Montoro on 18/7/25.
//

import Foundation

final class DetailTransformationsViewModel {
    
    //MARK: - Bindind con UI
    var detailViewState: ((DetailTransformationsStatusLoad) -> Void)?
    
    var transformation: NSMTransformations
    
    //MARK: Inits
    init(transformation: NSMTransformations) {
        self.transformation = transformation
    }
}
