//
//  HeroCollectionViewCell.swift
//  DragonBall_iOS_Avanzado
//
//  Created by Manuel Liebana Montoro on 18/7/25.
//

import UIKit

final class HeroCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Identifier
    static var identifier: String {
        return String(describing: self)
    }
    
    //MARK: - IBOutlets
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var heroNameLabel: UILabel!
    
    override func prepareForReuse() {
        heroImage.image = nil
        heroNameLabel.text = nil
    }
    
    //MARK: - Configure
    func configureWith(hero: NSMHero) {
        heroNameLabel.text = hero.name
        guard let imageURL = URL(string: hero.photo ?? "") else {
            return
        }
        heroImage.setImage(url: imageURL)
    }
}
