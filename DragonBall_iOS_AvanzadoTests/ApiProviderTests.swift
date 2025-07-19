//
//  ApiProviderTests.swift
//  DragonBall_iOS_Avanzado
//
//  Created by Manuel Liebana Montoro on 19/7/25.
//

import XCTest
@testable import DragonBall_iOS_Avanzado

final class ApiProviderTests: XCTestCase {
    
    private let host: URL = URL(string: "https://dragonball.keepcoding.education")!
    private var sut: ApiProvider!
    private var expectedToken: String = ""
    private var idHero: String = ""
    private let secureData = MockSegureDataUserDefault()

    //MARK: SetUp
    override func setUpWithError() throws {
        try super.setUpWithError()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        sut = ApiProvider(session: session, secureData: secureData)
        expectedToken = "test_token_12345"
        setToken()
        idHero = "D88BE50B-913D-4EA8-AC42-04D3AF1434E3"
    }

    // MARK: - TearDown
    override func tearDown() {
        super.tearDown()
        sut = nil
        MockURLProtocol.error = nil
        MockURLProtocol.handler = nil
        expectedToken = ""
        idHero = ""
    }
    
    //MARK: - TestLogin
    func test_logining() {
        // Given
        let (user, password) = ("user", "password")
        MockURLProtocol.handler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            let url = try XCTUnwrap(request.url)
            XCTAssertEqual(request.url, url)
            
            let loginString = String(format: "%@:%@", user, password)
            let base64String = loginString.data(using: .utf8)!.base64EncodedString()
            let expectedAuthorization = "Basic \(base64String)"
            let authorization = request.value(forHTTPHeaderField: "Authorization")
            XCTAssertEqual(authorization, expectedAuthorization)
            
            let response = MockURLProtocol.urlResponseFor(url: url, statusCode: 200)!
            let data = self.expectedToken.data(using: .utf8)!
            return (response, data)
        }
        // When
        let expectation = expectation(description: "Login success")
        sut.loginWith(email: user, password: password) { result in
            expectation.fulfill()
            switch result {
            case .success(let token):
                XCTAssertEqual(self.expectedToken, token)
            case .failure(_):
                XCTFail("expected fail")
            }
        }
        wait(for: [expectation], timeout: 0.2)
    }
    
    //MARK: - TestLoginFail
    func test_loginFail() {
        // Given
        let (user, password) = ("user", "password")
        MockURLProtocol.handler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            let url = try XCTUnwrap(request.url)
            XCTAssertEqual(request.url, url)
            
            let loginString = String(format: "%@:%@", user, password)
            let base64String = loginString.data(using: .utf8)!.base64EncodedString()
            let expectedAuthorization = "Basic \(base64String)"
            let authorization = request.value(forHTTPHeaderField: "Authorization")
            XCTAssertEqual(authorization, expectedAuthorization)
            
            let response = MockURLProtocol.urlResponseFor(url: url, statusCode: 401)!
            let data = self.expectedToken.data(using: .utf8)!
            return (response, data)
        }
        // When
        let expectation = expectation(description: "Login success")
        sut.loginWith(email: user, password: password) { result in
            expectation.fulfill()
            switch result {
            case .success(_):
                XCTFail("expected fail")
            case .failure(let error):
                XCTAssertEqual(error.description, "Error code 401")
            }
        }
        wait(for: [expectation], timeout: 0.2)
    }
    
    //MARK: - TestGetHeroes
    func test_getHeroes() {
        // Given
        let expectedHero = Hero.init(id: "14BB8E98-6586-4EA7-B4D7-35D6A63F5AA3",
                                     name: "Maestro Roshi",
                                     photo: "https://cdn.alfabetajuega.com/alfabetajuega/2020/06/Roshi.jpg?width=300",
                                     description: "Es un maestro de artes marciales que tiene una escuela, donde entrenará a Goku y Krilin para los Torneos de Artes Marciales.")
        MockURLProtocol.handler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            let url = try XCTUnwrap(request.url)
            
            let expectedAuthorization = "Bearer \(self.expectedToken)"
            let authorization = request.value(forHTTPHeaderField: "Authorization")
            XCTAssertEqual(authorization, expectedAuthorization)
            
            XCTAssertEqual(url, self.host.appendingPathComponent("/api/heros/all"))
            let mockUrl = try XCTUnwrap(Bundle(for: type(of: self)).url(forResource: "heroes", withExtension: "json"))
            let data = try Data(contentsOf: mockUrl)
            let response = try  XCTUnwrap(MockURLProtocol.urlResponseFor(url: url))
            
            return (response, data)
        }
        //When
        let expectation = expectation(description: "Load Heroes")
        sut.getHeroesWith { result in
            expectation.fulfill()
            switch result {
            case .success(let heroes):
                let hero = try? XCTUnwrap(heroes.first)
                XCTAssertEqual(hero?.id, expectedHero.id)
                XCTAssertEqual(hero?.name, expectedHero.name)
                XCTAssertEqual(hero?.photo, expectedHero.photo)
                XCTAssertTrue(hero!.description!.contains(expectedHero.description!))
                XCTAssertEqual(heroes.count, 16)
            case .failure(_):
                XCTFail("expected fail")
            }
        }
        wait(for: [expectation], timeout: 0.2)
    }
    
    func test_getHeroesFail() {
        // Given
        MockURLProtocol.handler = { request in
            let url = try XCTUnwrap(request.url)
            XCTAssertEqual(url, self.host.appendingPathComponent("/api/heros/all"))
            let mockUrl = try XCTUnwrap(Bundle(for: type(of: self)).url(forResource: "heroes", withExtension: "json"))
            let data = try Data(contentsOf: mockUrl)
            let response = try  XCTUnwrap(MockURLProtocol.urlResponseFor(url: url, statusCode: 401))
            
            return (response, data)
        }
        //When
        let expectation = expectation(description: "Load Heroes")
        sut.getHeroesWith { result in
            expectation.fulfill()
            switch result {
            case .success(_):
                XCTFail("expected fail")
            case .failure(let error):
                XCTAssertEqual(error.description, "Error code 401")
            }
        }
        wait(for: [expectation], timeout: 0.2)
    }
    
    //MARK: - TestGetTransformations
    func test_getTransformations() {
        // Given
        let expectedTransformation = Transformation.init(photo: "https://areajugones.sport.es/wp-content/uploads/2020/03/Gorilin.jpg.webp",
                                                         hero: nil,
                                                         id: "616ADA79-EF94-41BE-B4ED-3A44A3F3E2B7",
                                                         name: "4. Gorilin",
                                                         description: "Es la fusión de  Krillin y Kid Goku que apareció por primera vez en Dragon Ball Fusions.")
        
        MockURLProtocol.handler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            
            let expectedAuthorization = "Bearer \(self.expectedToken)"
            let authorization = request.value(forHTTPHeaderField: "Authorization")
            XCTAssertEqual(authorization, expectedAuthorization)
            
            let url = try XCTUnwrap(request.url)
            XCTAssertEqual(url, self.host.appendingPathComponent("/api/heros/tranformations"))
            let mockUrl = try XCTUnwrap(Bundle(for: type(of: self)).url(forResource: "transformations", withExtension: "json"))
            let data = try Data(contentsOf: mockUrl)
            let response = try  XCTUnwrap(MockURLProtocol.urlResponseFor(url: url))
            
            return (response, data)
        }
        //When
        let expectation = expectation(description: "Load Transformations")
        sut.getTransformationsForHeroWith(id: idHero) { result in
            expectation.fulfill()
            switch result {
            case .success(let transformations):
                let transformation = try? XCTUnwrap(transformations.first)
                XCTAssertEqual(transformation?.id, expectedTransformation.id)
                XCTAssertEqual(transformation?.name, expectedTransformation.name)
                XCTAssertEqual(transformation?.photo, expectedTransformation.photo)
                XCTAssertEqual(transformation?.description, expectedTransformation.description)
                XCTAssertEqual(transformations.count, 4)
            case .failure(_):
                XCTFail("expected fail")
            }
        }
        wait(for: [expectation], timeout: 0.2)
    }
    
    func test_getTransformationsFail() {
        // Given
        MockURLProtocol.handler = { request in
            let url = try XCTUnwrap(request.url)
            XCTAssertEqual(url, self.host.appendingPathComponent("/api/heros/tranformations"))
            let mockUrl = try XCTUnwrap(Bundle(for: type(of: self)).url(forResource: "transformations", withExtension: "json"))
            let data = try Data(contentsOf: mockUrl)
            let response = try  XCTUnwrap(MockURLProtocol.urlResponseFor(url: url, statusCode: 401))
            
            return (response, data)
        }
        //When
        let expectation = expectation(description: "Load Transformations")
        sut.getTransformationsForHeroWith(id: idHero) { result in
            expectation.fulfill()
            switch result {
            case .success(_):
                XCTFail("expected fail")
            case .failure(let error):
                XCTAssertEqual(error.description, "Error code 401")
            }
        }
        wait(for: [expectation], timeout: 0.2)
    }
    
    //MARK: - TestGetLocations
    func test_getLocations() {
        // Given
        let expectedLocation = Location.init(id: "B93A51C8-C92C-44AE-B1D1-9AFE9BA0BCCC",
                                             latitude: "35.71867899343361",
                                             longitude: "139.8202084625344",
                                             date: "2022-02-20T00:00:00Z",
                                             hero: nil)
        
        MockURLProtocol.handler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            
            let expectedAuthorization = "Bearer \(self.expectedToken)"
            let authorization = request.value(forHTTPHeaderField: "Authorization")
            XCTAssertEqual(authorization, expectedAuthorization)
            
            let url = try XCTUnwrap(request.url)
            XCTAssertEqual(url, self.host.appendingPathComponent("/api/heros/locations"))
            let mockUrl = try XCTUnwrap(Bundle(for: type(of: self)).url(forResource: "locations", withExtension: "json"))
            let data = try Data(contentsOf: mockUrl)
            let response = try  XCTUnwrap(MockURLProtocol.urlResponseFor(url: url))
            
            return (response, data)
        }
        //When
        let expectation = expectation(description: "Load Locations")
        sut.getLocationsForHeroWith(id: idHero) { result in
            expectation.fulfill()
            switch result {
            case .success(let locations):
                let location = try? XCTUnwrap(locations.first)
                XCTAssertEqual(location?.id, expectedLocation.id)
                XCTAssertEqual(location?.date, expectedLocation.date)
                XCTAssertEqual(location?.latitude, expectedLocation.latitude)
                XCTAssertEqual(location?.longitude, expectedLocation.longitude)
                XCTAssertEqual(locations.count, 19)
            case .failure(_):
                XCTFail("expected fail")
            }
        }
        wait(for: [expectation], timeout: 0.2)
    }
    
    func test_getLocationsFail() {
        // Given
        MockURLProtocol.handler = { request in
            let url = try XCTUnwrap(request.url)
            XCTAssertEqual(url, self.host.appendingPathComponent("/api/heros/locations"))
            let mockUrl = try XCTUnwrap(Bundle(for: type(of: self)).url(forResource: "locations", withExtension: "json"))
            let data = try Data(contentsOf: mockUrl)
            let response = try  XCTUnwrap(MockURLProtocol.urlResponseFor(url: url, statusCode: 401))
            
            return (response, data)
        }
        //When
        let expectation = expectation(description: "Load Locations")
        sut.getLocationsForHeroWith(id: idHero) { result in
            expectation.fulfill()
            switch result {
            case .success(_):
                XCTFail("expected fail")
            case .failure(let error):
                XCTAssertEqual(error.description, "Error code 401")
            }
        }
        wait(for: [expectation], timeout: 0.2)
    }
    
    private func setToken() {
        secureData.setToken(token: self.expectedToken)
    }
}
