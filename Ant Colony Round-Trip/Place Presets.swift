//
//  Place Presets.swift
//  Ant Colony Round-Trip
//
//  Created by Robert Wiebe on 3/16/24.
//

import Foundation
import MapKit

extension MKMapItem {
    convenience init(name: String, coordinate: CLLocationCoordinate2D) {
        self.init(placemark: MKPlacemark(coordinate: coordinate))
        self.name = name
    }
}

class PlaceGroup: Identifiable {
    init(name: String, places: [MKMapItem]) {
        self.name = name
        self.places = places
    }
    
    let name: String // e.g. "Southern Europe"
    let places: [MKMapItem] // the places in the group
}

let PresetPlaceGroups: [PlaceGroup] = [
    PlaceGroup(name: "Example Place Group", places: [
        MKMapItem(name: "Fresno State", coordinate: .init(latitude: 36.81335, longitude: -119.7476))
    ]) // add place groups like this
] // Add place groups here
