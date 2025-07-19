//
//  DetailViewController.swift
//  DragonBall_iOS_Avanzado
//
//  Created by Manuel Liebana Montoro on 18/7/25.
//

import UIKit
import MapKit

final class DetailViewController: UIViewController {
    
    //MARK: - TypeAlias
    typealias DataSource = UICollectionViewDiffableDataSource<Int, NSMTransformations>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, NSMTransformations>
    
    //MARK: - IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var transformationsView: UIView!
    
    private var viewModel: DetailViewModel
    private var dataSource: DataSource?
    private let locationManager = CLLocationManager()
    
    //MARK: Inits
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: DetailViewController.self), bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAuthorizationStatus()
        setObservers()
        configureUI()
        viewModel.loadData()
        collectionView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Asegurar que el mapa se cargue correctamente
        mapView.setNeedsLayout()
        mapView.layoutIfNeeded()
        
        // Configuración adicional para evitar errores de recursos
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.mapView.setNeedsDisplay()
        }
    }
    
    @IBAction func changeMapType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        case 2:
            mapView.mapType = .hybrid
        default:
            break
        }
    }
    
}

//MARK: - Observers
extension DetailViewController {
    private func setObservers() {
        viewModel.detailViewState = { [weak self] status in
            switch status {
            case .loading(let isLoading):
                self?.loadingView.isHidden = !isLoading
            case .loaded:
                self?.loadingView.isHidden = true
                self?.setUpCollectionView()
                self?.checkTransformations()
                self?.updateDataInterface()
                
            case .errorNetwork(let errorMessage):
                self?.loadingView.isHidden = true
                print(errorMessage)
            }
        }
    }
}

//MARK: - MapView
extension DetailViewController: MKMapViewDelegate {
    
    private func checkTransformations() {
        if viewModel.transformations.isEmpty {
            transformationsView.isHidden = true
        }
    }
    
    private func configureUI() {
        nameLabel.text = viewModel.hero.name
        descriptionText.text = viewModel.hero.descrip
        
        // Configurar mapa correctamente
        mapView.delegate = self
        mapView.showsUserTrackingButton = true
        mapView.mapType = .standard // Asegurar que empiece en modo estándar
        
        // Configuraciones adicionales para evitar errores
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.showsTraffic = false
        mapView.showsBuildings = true
        
        // Configurar región por defecto (Madrid) para que el mapa se cargue
        let defaultRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 40.4168, longitude: -3.7038),
            latitudinalMeters: 100000,
            longitudinalMeters: 100000
        )
        mapView.setRegion(defaultRegion, animated: false)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 300, height: 150)
        collectionView.collectionViewLayout = layout
    }
    
    private func updateDataInterface() {
        addAnnotations()
        
        if let annotation = mapView.annotations.first {
            // Si hay ubicaciones, centrar en la primera
            let region = MKCoordinateRegion(center: annotation.coordinate,
                                            latitudinalMeters: 100000,
                                            longitudinalMeters: 100000)
            mapView.setRegion(region, animated: true)
        } else {
            // Si no hay ubicaciones, mantener la región por defecto (Madrid)
            let defaultRegion = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 40.4168, longitude: -3.7038),
                latitudinalMeters: 100000,
                longitudinalMeters: 100000
            )
            mapView.setRegion(defaultRegion, animated: false)
        }
    }
    
    private func addAnnotations() {
        var annotations = [HeroAnnotation]()
        let name = viewModel.hero.name
        let id = viewModel.hero.id
        
        for location in viewModel.locations {
            let lat = Double(location.latitude ?? "") ?? 0.0
            let lon = Double(location.longitude ?? "") ?? 0.0
            
            annotations.append(
                HeroAnnotation.init(coordinate: .init(latitude: lat, longitude: lon),
                                    title: name,
                                    id: id,
                                    date: location.date)
            )
        }
        mapView.addAnnotations(annotations)
    }
    
    func checkLocationAuthorizationStatus() {
        let status = locationManager.authorizationStatus
        switch status {
        case .notDetermined: locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted: mapView.showsUserLocation = false
        case .authorizedAlways, .authorizedWhenInUse: mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        guard let heroAnnotation = annotation as? HeroAnnotation else {
            return
        }
        debugPrint("Annotation selected of hero \(heroAnnotation.title ?? "")")
        debugPrint("Located on  \(heroAnnotation.date ?? "")")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is HeroAnnotation else {
            return nil
        }

        if let annotation = mapView.dequeueReusableAnnotationView(withIdentifier: HeroAnnotationView.reuseIdentifier) {
            return annotation
        }
        return HeroAnnotationView.init(annotation: annotation, reuseIdentifier: HeroAnnotationView.reuseIdentifier)
    }
    

}

//MARK: - Delegate CollectionView
extension DetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let transformation = viewModel.transformation(indexPath: indexPath) else {return}
        let viewModel = DetailTransformationsViewModel(transformation: transformation)
        let nextVC = DetailTransformationsViewController(viewModel: viewModel)
        let sheet = nextVC.sheetPresentationController
        sheet?.detents = [.medium(), .large()]
        self.present (nextVC, animated: true)
    }
}

// MARK: - setUp CollectionView
extension DetailViewController {
    func setUpCollectionView() {
        let registration = UICollectionView.CellRegistration<TransformationCollectionViewCell, NSMTransformations>(
            cellNib: UINib(
                nibName: TransformationCollectionViewCell.identifier,
                bundle: nil
            )
        ) { cell, _, transformation in
            cell.configureWith(transformation: transformation)
        }
        
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, transformation in
            collectionView.dequeueConfiguredReusableCell(
                using: registration,
                for: indexPath,
                item: transformation
            )
        }
        
        collectionView.dataSource = dataSource
        
        DispatchQueue.main.async {
            self.viewModel.sortDescriptor()
            var snapshot = Snapshot()
            snapshot.appendSections([0])
            snapshot.appendItems(self.viewModel.transformations)
            self.dataSource?.apply(snapshot)
        }
    }
}
