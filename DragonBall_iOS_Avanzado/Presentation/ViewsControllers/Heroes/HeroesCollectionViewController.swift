//
//  HeroesCollectionViewController.swift
//  DragonBall_iOS_Avanzado
//
//  Created by Manuel Liebana Montoro on 18/7/25.
//

import UIKit

final class HeroesCollectionViewController: UIViewController {
    
    //MARK: - TypeAlias
    typealias DataSource = UICollectionViewDiffableDataSource<Int, NSMHero>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, NSMHero>
    
    //MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - BindingViewModel
    private var viewModel: HeroesViewModel
    
    private var dataSource: DataSource?
    
    //MARK: Inits
    init(viewModel: HeroesViewModel = HeroesViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: HeroesCollectionViewController.self), bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadData()
        setupNavigationBarWithLogout()
        setObservers()
        collectionView.delegate = self
    }
}

//MARK: - Extension
extension HeroesCollectionViewController {
    //MARK: - Observers
    private func setObservers() {
        viewModel.heroesViewState = { [weak self] status in
            switch status {
            case .loading(let isLoading):
                self?.loadingView.isHidden = !isLoading
            case .loaded:
                self?.setUpCollectionView()
                self?.setUpViewController()
                self?.loadingView.isHidden = true
            case .errorNetwork(let errorMessage):
                self?.loadingView.isHidden = true
                print(errorMessage)
            }
        }
    }
    //MARK: - SetUp
    private func setUpViewController() {
        let segmentedControl = UISegmentedControl(items: ["A - Z", "Z - A"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: segmentedControl)
        navigationItem.title = "HEROES"
    }
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let ascending = sender.selectedSegmentIndex == 0 ? true : false
        viewModel.sortDescriptor(ascending: ascending)
        setUpCollectionView()
    }
}

//MARK: - Delegate
extension HeroesCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let hero = viewModel.hero(indexPath: indexPath) else {return}
        let viewModel = DetailViewModel(hero: hero)
        let nextVC = DetailViewController(viewModel: viewModel)
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

// MARK: - setUp CollectionView
extension HeroesCollectionViewController {
    func setUpCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 190, height: 190)
        collectionView.collectionViewLayout = layout
        
        let registration = UICollectionView.CellRegistration<HeroCollectionViewCell, NSMHero>(
            cellNib: UINib(
                nibName: HeroCollectionViewCell.identifier,
                bundle: nil
            )
        ) { cell, _, hero in
            cell.configureWith(hero: hero)
        }
        
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, hero in
            collectionView.dequeueConfiguredReusableCell(
                using: registration,
                for: indexPath,
                item: hero
            )
        }
        
        collectionView.dataSource = dataSource
        
        DispatchQueue.main.async {
            var snapshot = Snapshot()
            snapshot.appendSections([0])
            snapshot.appendItems(self.viewModel.heroes)
            self.dataSource?.apply(snapshot)
        }
    }
}

