//
//  ApiProvider.swift
//  DragonBall_iOS_Avanzado
//
//  Created by Manuel Liebana Montoro on 18/7/25.
//

import Foundation

final class ApiProvider {
    
    private var session: URLSession
    private var requestProvider: RequestProvider
    private var secureData: SecureDataKeychainProtocol
    private var storeData: StoreDataProvider
    
    //MARK: - Inits
    init(session: URLSession = URLSession.shared,
         requestProvider: RequestProvider = RequestProvider(),
         secureData: SecureDataKeychainProtocol = SecureDataKeychain(),
         storeData: StoreDataProvider = StoreDataProvider.shared) {
        self.session = session
        self.requestProvider = requestProvider
        self.secureData = secureData
        self.storeData = storeData
    }
    
    //MARK: - Login
    func loginWith(email: String,
                   password: String,
                   completion: @escaping (Result<String, NetworkError>) -> Void) {
        let loginString = String(format: "%@:%@", email, password)
        guard let loginData = loginString.data(using: .utf8) else {
            completion(.failure(.dataFormatting))
            return
        }
        let base64LoginString = loginData.base64EncodedString()
        var request = requestProvider.requestFor(endPoint: .login)
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        makeRequestFor(request: request, completion: completion)
    }
    
    //MARK: - Get Heroes
    func getHeroesWith (name: String? = nil,
                        completion: @escaping (Result<[Hero], NetworkError>) -> Void) {
        guard let token = secureData.getToken() else {
            completion(.failure(.tokenFormatError))
            return
        }
        let request = requestProvider.requestFor(endPoint: .heroes, token: token,
                                                 params: ["name" : name ?? ""])
        makeRequestFor(request: request, completion: completion)
    }
    
    //MARK: - Get Transformations
    func getTransformationsForHeroWith(id: String,
                                       completion: @escaping (Result<[Transformation], NetworkError>) -> Void) {
        guard let token = secureData.getToken() else {
            completion(.failure(.tokenFormatError))
            return
        }
        let request = requestProvider.requestFor(endPoint: .transformations, token: token,
                                                 params: ["id" : id])
        makeRequestFor(request: request, completion: completion)
    }
    
    //MARK: - Get Locations
    func getLocationsForHeroWith(id: String,
                                 completion: @escaping (Result<[Location], NetworkError>) -> Void) {
        guard let token = secureData.getToken() else {
            completion(.failure(.tokenFormatError))
            return
        }
        let request = requestProvider.requestFor(endPoint: .locations, token: token,
                                                 params: ["id": id])
        makeRequestFor(request: request, completion: completion)
    }
}

//MARK: - Extension Make Request
extension ApiProvider {
    
    private func makeRequestFor(request: URLRequest,
                        completion: @escaping (Result<String, NetworkError>) -> Void) {

        session.dataTask(with: request) { [weak self] data, response, error in
            guard error == nil else {
                completion(.failure(.other))
                return
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            guard statusCode == HTTPResponseCodes.SUCCESS else {
                completion(.failure(.errorCode(statusCode)))
                return
            }
            guard let token = String(data: data, encoding: .utf8) else {
                completion(.failure(.tokenFormatError))
                return
            }
            completion(.success(token))
            self?.secureData.setToken(token: token)
        }
        .resume()
    }
    
    private func makeRequestFor<T: Decodable>(request: URLRequest,
                                      completion: @escaping (Result<[T], NetworkError>) -> Void) {
        
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.other))
                return
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            guard statusCode == HTTPResponseCodes.SUCCESS else {
                completion(.failure(.errorCode(statusCode)))
                return
            }
            guard let response = try? JSONDecoder().decode([T].self, from: data) else {
                completion(.failure(.decoding))
                return
            }
            completion(.success(response))
        }
        .resume()
    }
}
