//
//  HeroesViewModel.swift
//  DragonBall_iOS_Avanzado
//
//  Created by Manuel Liebana Montoro on 18/7/25.
//

import Foundation
import CoreData

final class HeroesViewModel {
    
    //MARK: - Binding con UI
    var heroesViewState: ((HeroesStatusLoad) -> Void)?
    
    //MARK: - Binding con Api
    private var apiProvider: ApiProvider
    private var storeDataProvider : StoreDataProvider
    var heroes: [NSMHero] = []
    
    //MARK: - Inits
    init(apiProvider: ApiProvider = ApiProvider(),
         storeDataProvider: StoreDataProvider = StoreDataProvider.shared) {
        self.apiProvider = apiProvider
        self.storeDataProvider = storeDataProvider
        self.addObservers()
    }
    
    deinit {
        removeObservers()
    }
    
    //MARK: - Load Data
    func loadData() {
        heroesViewState?(.loading(true))
        sortDescriptor()
        if heroes.isEmpty {
            getHeroes()
        } else {
            notifyDataUpdated()
        }
    }
    
    //MARK: - NotificationLoadData
    private func notifyDataUpdated() {
        DispatchQueue.main.async {
            self.heroesViewState?(.loaded)
        }
    }
    //MARK: - SelectHero
    func hero(indexPath: IndexPath) -> NSMHero? {
        guard indexPath.row < heroes.count else {return nil }
        return heroes[indexPath.row]
    }
    
    //MARK: - GetHeroesApi
    private func getHeroes() {
        apiProvider.getHeroesWith { [weak self] result in
            switch result {
            case .success(let heroes):
                var custonListHeroes = heroes
                custonListHeroes.removeAll { $0.name == "Quake (Daisy Johnson)"}
                self?.storeDataProvider.insert(heroes: custonListHeroes)
                self?.notifyDataUpdated()
            case .failure(let error):
                debugPrint("Error loading heroes \(error.description)")
            }
        }
    }
    
    //MARK: - SortDescriptor
    func sortDescriptor(ascending: Bool = true ) {
        let sort = NSSortDescriptor(keyPath: \NSMHero.name, ascending: ascending)
        self.heroes = self.storeDataProvider.fetchHeroes(sorting: [sort])
    }
    
    //MARK: - Observers
    private func addObservers() {
        NotificationCenter.default.addObserver(forName: NSManagedObjectContext.didSaveObjectsNotification, object: nil, queue: .main) { [weak self] notification in
            self?.sortDescriptor()
        }
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
}
