//
//  HeroAnnotationView.swift
//  DragonBall_iOS_Avanzado
//
//  Created by Manuel Liebana Montoro on 18/7/25.
//

import Foundation
import MapKit

final class HeroAnnotationView: MKAnnotationView {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        canShowCallout = true
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = .clear
        let image = UIImage.init(named: "bola_dragon")
        let view = UIImageView.init(image: image)
        view.frame = bounds
        addSubview(view)
    }
}
