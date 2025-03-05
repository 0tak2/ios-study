//
//  ViewController.swift
//  MapKitPractice
//
//  Created by 임영택 on 3/1/25.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    private let mapView = MKMapView()
    private let controlView = MapControlView()
    private let locationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "location.circle"), for: .normal)
        button.backgroundColor = .black
        button.alpha = 0.8
        return button
    }()
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let initialLocation = CLLocation(latitude: 37.559975221378, longitude: 126.975312652739)
    private var regionRadius = 1000.0
    private let zoomFactor = 0.5
    
    private var locationManager: CLLocationManager!
    private lazy var userLocation: UserLocation = .init(coordinate: self.initialLocation.coordinate) {
        didSet {
            mapView.removeAnnotation(oldValue)
            mapView.addAnnotation(self.userLocation)
            self.updateUserAddress(location: CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude))
        }
    }
    private var userAddress: String = "" {
        didSet {
            addressLabel.text = userAddress
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Map View
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        mapView.centerToLocation(initialLocation, regionRadius: regionRadius)
        
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
        mapView.setCameraZoomRange(zoomRange, animated: true)
        
        // MARK: Control View
        controlView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controlView)
        NSLayoutConstraint.activate([
            controlView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            controlView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            controlView.widthAnchor.constraint(equalToConstant: 48),
            controlView.heightAnchor.constraint(equalToConstant: 96),
        ])
        
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(locationButton)
        NSLayoutConstraint.activate([
            locationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            locationButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            locationButton.widthAnchor.constraint(equalToConstant: 48),
            locationButton.heightAnchor.constraint(equalToConstant: 48),
        ])
        
        controlView.plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        controlView.minusButton.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        locationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
        
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addressLabel)
        NSLayoutConstraint.activate([
            addressLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            addressLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        // MARK: User's Location
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
}

extension ViewController {
    @objc private func plusButtonTapped() {
        adjustZoomLevel(to: .zoomIn)
    }
    
    @objc private func minusButtonTapped() {
        adjustZoomLevel(to: .zoomOut)
    }
    
    @objc private func locationButtonTapped() {
        if let currentLocation = self.locationManager.location {
            updateUserLocation(for: currentLocation)
        }
    }
    
    private func adjustZoomLevel(to direction: ZoomDirection) {
        var region = mapView.region
        
        if direction == .zoomIn {
            region.span.latitudeDelta *= zoomFactor
            region.span.longitudeDelta *= zoomFactor
        } else {
            region.span.latitudeDelta /= zoomFactor
            region.span.longitudeDelta /= zoomFactor
        }
        
        mapView.setRegion(region, animated: true)
    }
    
    private func updateUserLocation(for location: CLLocation) {
        self.userLocation = UserLocation(coordinate: location.coordinate)
        mapView.centerToLocation(location)
    }
    
    private func updateUserAddress(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, preferredLocale: Locale(identifier: "ko-KR")) { places, error in
            guard error == nil else {
                print("reverseGeocodeLocation error - \(error?.localizedDescription ?? "N/A")")
                return
            }
            
            if let places = places {
                /**
                 CLPlacemark
                 
                 var thoroughfare: String?
                 The street address associated with the placemark.
                 
                 var subThoroughfare: String?
                 Additional street-level information for the placemark.
                 
                 var locality: String?
                 The city associated with the placemark.
                 
                 var subLocality: String?
                 Additional city-level information for the placemark.
                 
                 var administrativeArea: String?
                 The state or province associated with the placemark.
                 
                 var subAdministrativeArea: String?
                 Additional administrative area information for the placemark.
                 
                 var postalCode: String?
                 The postal code associated with the placemark.
                 */
                guard let firstPlace = places.first else { return }
                print("country: \(firstPlace.country ?? "")")
                print("thoroughfare: \(firstPlace.thoroughfare ?? "")")
                print("subThoroughfare: \(firstPlace.subThoroughfare ?? "")")
                print("locality: \(firstPlace.locality ?? "")")
                print("subLocality: \(firstPlace.subLocality ?? "")")
                print("administrativeArea: \(firstPlace.administrativeArea ?? "")")
                print("subAdministrativeArea: \(firstPlace.subAdministrativeArea ?? "")")
                print("postalCode: \(firstPlace.postalCode ?? "")")
                
                // MARK: Full Address
                let formattedAddressLines = firstPlace.addressDictionary?["FormattedAddressLines"] as? [String]
                print("formattedAddressLines: \(formattedAddressLines ?? [])")
                
                // MARK: debugDescription
                let debugDescription = firstPlace.debugDescription
                print("debugDescription: \(debugDescription)")
                // 용강동 112-12, 대한민국 서울특별시 마포구 용강동 112-12, 04166 @ <+37.54129517,+126.94210786> +/- 100.00m, region CLCircularRegion (identifier:'<+37.54123010,+126.94214170> radius 70.65', center:<+37.54123010,+126.94214170>, radius:70.65m)
                
                do {
                    let regex = /대한민국.*?,/
                    if let match = try regex.firstMatch(in: debugDescription) {
                        let matchedString = match.output // "대한민국 서울특별시 마포구 용강동 112-12,"
                        let addressComponents = matchedString.split(separator: " ")
                        if addressComponents.count >= 4 {
                            let districtName = "\(addressComponents[2])"
                            let localityNameFallback = "\(addressComponents[3])"
                            let shortAddress = "\(districtName) \(firstPlace.subLocality ?? localityNameFallback)"
                            print("result: \(shortAddress)")
                            self.userAddress = shortAddress
                        }
                    }
                } catch {
                    print("faild to parse debugDescription... error: \(error.localizedDescription)")
                }
            }
        }
    }
}

private enum ZoomDirection {
    case zoomIn
    case zoomOut
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse,
           let currentLocation = manager.location {
            updateUserLocation(for: currentLocation)
        }
    }
}

private extension MKMapView {
    func centerToLocation (_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius
        )
        
        self.setRegion(coordinateRegion, animated: true)
    }
}
