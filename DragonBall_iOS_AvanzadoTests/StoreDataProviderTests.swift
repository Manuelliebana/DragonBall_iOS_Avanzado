//
//  StoreDataProviderTests.swift
//  DragonBall_iOS_Avanzado
//
//  Created by Manuel Liebana Montoro on 19/7/25.
//

import XCTest
@testable import DragonBall_iOS_Avanzado

final class StoreDataProviderTests: XCTestCase {
    
    var sut: StoreDataProvider!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = StoreDataProvider(storeType: .inMemory)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_insertHeroes() {
        //Given
        let initialCount = sut.fetchHeroes().count
        XCTAssertEqual(initialCount, 0)
        
        //When
        let newHero = Hero(id: "idHero",
                           name: "nameHero",
                           photo: "photoHero",
                           description: "descriptionHero")
        sut.insert(heroes: [newHero])
        
        //Then
        let finalCount = sut.fetchHeroes().count
        XCTAssertEqual(finalCount, 1)
        let hero = sut.fetchHeroes().first
        XCTAssertEqual(hero?.id, newHero.id)
        XCTAssertEqual(hero?.name, newHero.name)
        XCTAssertEqual(hero?.photo, newHero.photo)
        XCTAssertEqual(hero?.descrip, newHero.description)

    }
    
    func test_insertTransformations() {
        //Given
        let initialCount = sut.fetchTransformations().count
        XCTAssertEqual(initialCount, 0)
        
        //When
        let newTransformation = Transformation(photo: "photo",
                                               hero: nil,
                                               id: "id",
                                               name: "name",
                                               description: "description")
        sut.insert(transformations: [newTransformation])
        
        //Then
        let finalCount = sut.fetchTransformations().count
        XCTAssertEqual(finalCount, 1)
        let transformation = sut.fetchTransformations().first
        XCTAssertEqual(transformation?.id, newTransformation.id)
        XCTAssertEqual(transformation?.name, newTransformation.name)
        XCTAssertEqual(transformation?.photo, newTransformation.photo)
        XCTAssertEqual(transformation?.descrip, newTransformation.description)
    }
    
    func test_insertLocations() {
        //Given
        let initialCount = sut.fetcLocations().count
        XCTAssertEqual(initialCount, 0)
        
        //When
        let newLocation = Location(id: "id",
                                   latitude: "latitude",
                                   longitude: "longitude",
                                   date: "date",
                                   hero: nil)
        sut.insert(locations: [newLocation])
        
        //Then
        let finalCount = sut.fetcLocations().count
        XCTAssertEqual(finalCount, 1)
        let location = sut.fetcLocations().first
        XCTAssertEqual(location?.id, newLocation.id)
        XCTAssertEqual(location?.latitude, newLocation.latitude)
        XCTAssertEqual(location?.longitude, newLocation.longitude)
        XCTAssertEqual(location?.date, newLocation.date)

    }
    
    func test_updateHero() {
        //Given
        let newHero = Hero(id: "idHero",
                           name: "nameHero",
                           photo: "photoHero",
                           description: "descriptionHero")
        sut.insert(heroes: [newHero])
        
        //When
        let newHero2 = Hero(id: "idHero",
                           name: "nameHeroUpdated",
                           photo: "photoHeroUpdated",
                           description: "descriptionHeroUpdated")
        sut.insert(heroes: [newHero2])
        
        //Then
        let hero = sut.fetchHeroes().first
        XCTAssertEqual(hero?.name, newHero2.name)
        let finalCount = sut.fetchHeroes().count
        XCTAssertEqual(finalCount, 1)
    }
    
    func test_updateTransformation() {
        //Given
        let newTransformation = Transformation(photo: "photo",
                                               hero: nil,
                                               id: "id",
                                               name: "name",
                                               description: "description")
        sut.insert(transformations: [newTransformation])
        
        //When
        let newTransformation2 = Transformation(photo: "photoUpdated",
                                               hero: nil,
                                               id: "id",
                                               name: "nameUpdated",
                                               description: "descriptionUpdated")
        sut.insert(transformations: [newTransformation2])
        
        //Then
        let transformation = sut.fetchTransformations().first
        XCTAssertEqual(transformation?.name, newTransformation2.name)
        let finalCount = sut.fetchTransformations().count
        XCTAssertEqual(finalCount, 1)
    }
    
    func test_updateLocation() {
        //Given
        let newLocation = Location(id: "id",
                                   latitude: "latitude",
                                   longitude: "longitude",
                                   date: "date",
                                   hero: nil)
        sut.insert(locations: [newLocation])
        
        //When
        let newLocation2 = Location(id: "id",
                                   latitude: "latitudeUpdated",
                                   longitude: "longitudeUpdated",
                                   date: "dateUpdated",
                                   hero: nil)
        sut.insert(locations: [newLocation2])
        
        //Then
        let location = sut.fetcLocations().first
        XCTAssertEqual(location?.latitude, newLocation2.latitude)
        let finalCount = sut.fetcLocations().count
        XCTAssertEqual(finalCount, 1)
    }
    
    
    func test_clearBBDD() {
        //Given
        let newHero = Hero(id: "idHero",
                           name: "nameHero",
                           photo: "photoHero",
                           description: "descriptionHero")
        sut.insert(heroes: [newHero])
        let newTransformation = Transformation(photo: "photo",
                                               hero: nil,
                                               id: "id",
                                               name: "name",
                                               description: "description")
        sut.insert(transformations: [newTransformation])
        let newLocation = Location(id: "id",
                                   latitude: "latitude",
                                   longitude: "longitude",
                                   date: "date",
                                   hero: nil)
        sut.insert(locations: [newLocation])
        
        XCTAssertEqual(sut.fetchHeroes().count, 1)
        XCTAssertEqual(sut.fetchTransformations().count, 1)
        XCTAssertEqual(sut.fetcLocations().count, 1)
        
        //When
        sut.clearBBDD()
        
        //Then
        XCTAssertEqual(sut.fetchHeroes().count, 0)
        XCTAssertEqual(sut.fetchTransformations().count, 0)
        XCTAssertEqual(sut.fetcLocations().count, 0)
    }

}
