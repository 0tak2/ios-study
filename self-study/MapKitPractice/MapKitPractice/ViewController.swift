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
    private let initialLocation = CLLocation(latitude: 37.559975221378, longitude: 126.975312652739)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        mapView.centerToLocation(initialLocation)
        
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
        mapView.setCameraZoomRange(zoomRange, animated: true)
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
