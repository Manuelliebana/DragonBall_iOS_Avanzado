//
//  TestSetup.swift
//  DragonBall_iOS_AvanzadoTests
//
//  Created by Manuel Liebana Montoro on 19/7/25.
//

import XCTest
@testable import DragonBall_iOS_Avanzado

final class TestSetup: XCTestCase {
    
    func test_basicSetup() {
        // Verificar que podemos acceder a los modelos
        let hero = Hero(id: "test", name: "Test Hero", photo: "test.jpg", description: "Test description")
        XCTAssertEqual(hero.name, "Test Hero")
        
        let location = Location(id: "test", latitude: "40.0", longitude: "-3.0", date: "2024-01-01", hero: nil)
        XCTAssertEqual(location.latitude, "40.0")
        
        let transformation = Transformation(photo: "test.jpg", hero: nil, id: "test", name: "Test Transform", description: "Test desc")
        XCTAssertEqual(transformation.name, "Test Transform")
    }
    
    func test_mockSetup() {
        // Verificar que el mock funciona
        let mockSecureData = MockSegureDataUserDefault()
        mockSecureData.setToken(token: "test_token")
        XCTAssertEqual(mockSecureData.getToken(), "test_token")
    }
} 