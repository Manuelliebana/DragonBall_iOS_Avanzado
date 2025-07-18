//
//  NSMHero.swift
//  DragonBall_iOS_Avanzado
//
//  Created by Manuel Liebana Montoro on 18/7/25.
//

import Foundation
import CoreData

@objc(NSMHero)
public class NSMHero: NSManagedObject {

}

extension NSMHero {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NSMHero> {
        return NSFetchRequest<NSMHero>(entityName: "Hero")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: String
    @NSManaged public var photo: String?
    @NSManaged public var descrip: String?
    @NSManaged public var heroToTransformations: Set<NSMTransformations>?
    @NSManaged public var heroToLocations: Set<NSMLocations>?

}

// MARK: Generated accessors for hetoToTransformations
extension NSMHero {

    @objc(addHetoToTransformationsObject:)
    @NSManaged public func addToHetoToTransformations(_ value: NSMTransformations)

    @objc(removeHetoToTransformationsObject:)
    @NSManaged public func removeFromHetoToTransformations(_ value: NSMTransformations)

    @objc(addHetoToTransformations:)
    @NSManaged public func addToHetoToTransformations(_ values: Set<NSMTransformations>)

    @objc(removeHetoToTransformations:)
    @NSManaged public func removeFromHetoToTransformations(_ values: Set<NSMTransformations>)

}

// MARK: Generated accessors for heroToLocations
extension NSMHero {

    @objc(addHeroToLocationsObject:)
    @NSManaged public func addToHeroToLocations(_ value: NSMLocations)

    @objc(removeHeroToLocationsObject:)
    @NSManaged public func removeFromHeroToLocations(_ value: NSMLocations)

    @objc(addHeroToLocations:)
    @NSManaged public func addToHeroToLocations(_ values: Set<NSMLocations>)

    @objc(removeHeroToLocations:)
    @NSManaged public func removeFromHeroToLocations(_ values: Set<NSMLocations>)

}

extension NSMHero : Identifiable {

}
