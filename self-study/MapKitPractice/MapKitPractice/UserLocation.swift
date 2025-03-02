//
//  UserLocation.swift
//  MapKitPractice
//
//  Created by 임영택 on 3/2/25.
//

import MapKit

final class UserLocation: NSObject, MKAnnotation {
    private(set) var coordinate: CLLocationCoordinate2D
    private(set) var title: String? = "나의 위치"
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
