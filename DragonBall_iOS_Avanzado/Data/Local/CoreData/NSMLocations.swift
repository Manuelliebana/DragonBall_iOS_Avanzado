//
//  NSMLocations.swift
//  DragonBall_iOS_Avanzado
//
//  Created by Manuel Liebana Montoro on 18/7/25.
//

import Foundation
import CoreData

@objc(NSMLocations)
public class NSMLocations: NSManagedObject {

}

extension NSMLocations {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NSMLocations> {
        return NSFetchRequest<NSMLocations>(entityName: "Locations")
    }

    @NSManaged public var id: String?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var date: String?
    @NSManaged public var hero: NSMHero?

}

extension NSMLocations : Identifiable {

}
