//
//  StoreDataProvider.swift
//  DragonBall_iOS_Avanzado
//
//  Created by Manuel Liebana Montoro on 18/7/25.
//

import Foundation
import CoreData

enum StoreType {
    case disk
    case inMemory
}

final class StoreDataProvider {
    
    static var shared = StoreDataProvider()
    private let persistenContainer: NSPersistentContainer
    
    private static var model: NSManagedObjectModel = {
        let bundle = Bundle(for: StoreDataProvider.self)
        guard  let url = bundle.url(forResource: "Model", withExtension: "momd"),
               let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError(" Error loading model file")
        }
        return model
    }()
    
    lazy var context: NSManagedObjectContext = {
        var viewContext = persistenContainer.viewContext
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        return viewContext
    }()
    
    init(storeType: StoreType = .disk) {
        self.persistenContainer = NSPersistentContainer(name: "Model", managedObjectModel: Self.model)
        if  storeType == .inMemory {
            if let store = self.persistenContainer.persistentStoreDescriptions.first {
                store.url = URL(filePath: "dev/null")
            } else {
                fatalError(" Error loading persistent Store Description")
            }
        }
        self.persistenContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Error creating BBDD \(error)")
            }
        }
    }
}

extension StoreDataProvider {
    
    func insert(heroes: [Hero]) {
        context.performAndWait {
            for hero in heroes {
                let newHero = NSMHero(context: context)
                newHero.id = hero.id
                newHero.name = hero.name
                newHero.photo = hero.photo
                newHero.descrip = hero.description
            }
            self.saveContext()
        }
    }
    
    func fetchHeroes(filter: NSPredicate? = nil,
                     sorting: [NSSortDescriptor]? = nil) -> [NSMHero] {
        
        let request = NSMHero.fetchRequest()
        request.predicate = filter
        request.sortDescriptors = sorting
        if sorting == nil {
            let sort = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [sort]
        } else {
            request.sortDescriptors = sorting
        }
        do {
            return try context.fetch(request)
        } catch {
            return []
        }
    }
    
    func insert(transformations: [Transformation]) {
        context.performAndWait {
            for transformation in transformations {
                let newTransformation = NSMTransformations(context: context)
                newTransformation.id = transformation.id
                newTransformation.name = transformation.name
                newTransformation.photo = transformation.photo
                newTransformation.descrip = transformation.description
                let filter = NSPredicate(format: "id == %@", transformation.hero?.id ?? "")
                newTransformation.hero = self.fetchHeroes(filter: filter).first
            }
            self.saveContext()
        }
    }
    
    func fetchTransformations(filter: NSPredicate? = nil,
                     sorting: [NSSortDescriptor]? = nil) -> [NSMTransformations] {
        
        let request = NSMTransformations.fetchRequest()
        request.predicate = filter
        request.sortDescriptors = sorting
        if sorting == nil {
            let sort = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [sort]
        } else {
            request.sortDescriptors = sorting
        }
        do {
            return try context.fetch(request)
        } catch {
            return []
        }
    }

    
    func insert(locations: [Location]) {
        context.performAndWait {
            for location in locations {
                let newLocation = NSMLocations(context: context)
                newLocation.id = location.id
                newLocation.latitude = location.latitude
                newLocation.longitude = location.longitude
                newLocation.date = location.date
                let filter = NSPredicate(format: "id == %@", location.hero?.id ?? "")
                newLocation.hero = self.fetchHeroes(filter: filter).first
            }
            self.saveContext()
        }
    }
    
    func fetcLocations() -> [NSMLocations] {
        let request = NSMLocations.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    

    
    func clearBBDD() {
        let deleteHeroes = NSBatchDeleteRequest(fetchRequest: NSMHero.fetchRequest())
        let deleteTransformations = NSBatchDeleteRequest(fetchRequest: NSMTransformations.fetchRequest())
        let deleteLocations = NSBatchDeleteRequest(fetchRequest: NSMLocations.fetchRequest())
        context.reset()
        
        for task in [deleteHeroes, deleteTransformations, deleteLocations] {
            do {
               try  context.execute(task)
            } catch {
                debugPrint("Error cleaing BBDD")
            }
        }
    }
    

    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
                debugPrint("Error saving changes in BBDD")
            }
        }
    }
}
