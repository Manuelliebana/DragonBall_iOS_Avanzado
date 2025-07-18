//
//  HeroAnnotation.swift
//  DragonBall_iOS_Avanzado
//
//  Created by Manuel Liebana Montoro on 18/7/25.
//

import Foundation
import MapKit

class HeroAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var id: String?
    var date: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String? = nil, id: String? = nil, date: String? = nil) {
        self.coordinate = coordinate
        self.title = title
        self.id = id
        self.date = date
    }
}
