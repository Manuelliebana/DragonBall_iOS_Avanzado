//
//  TransformationCollectionViewCell.swift
//  DragonBall_iOS_Avanzado
//
//  Created by Manuel Liebana Montoro on 18/7/25.
//

import UIKit

final class TransformationCollectionViewCell: UICollectionViewCell {


    //MARK: - Identifier
    static var identifier: String {
        return String(describing: self)
    }
    
    //MARK: - IBOutlets
    @IBOutlet weak var transformationImage: UIImageView!
    @IBOutlet weak var transformationLabel: UILabel!
    
    //MARK: - Configure
    func configureWith(transformation: NSMTransformations) {
        transformationLabel.text = transformation.name
        guard let imageURL = URL(string: transformation.photo ?? "") else {
            return
        }
        transformationImage.setImage(url: imageURL)
    }
}

