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
    PlaceGroup(name: "Germany", places: [
        MKMapItem(name: "Berlin", coordinate: .init(latitude: 52.52, longitude: 13.405)),
        MKMapItem(name: "Hamburg", coordinate: .init(latitude: 53.5488, longitude: 9.9872)),
        MKMapItem(name: "Munich", coordinate: .init(latitude: 48.1351, longitude: 11.582)),
        MKMapItem(name: "Cologne", coordinate: .init(latitude: 50.9375, longitude: 6.9603)),
        MKMapItem(name: "Frankfurt", coordinate: .init(latitude: 50.1109, longitude: 8.6821)),
        MKMapItem(name: "Stuttgart", coordinate: .init(latitude: 48.7758, longitude: 9.1829)),
        MKMapItem(name: "Dusseldorf", coordinate: .init(latitude: 51.223, longitude: 6.7825)),
        MKMapItem(name: "Leipzig", coordinate: .init(latitude: 51.3397, longitude: 12.3731)),
        MKMapItem(name: "Dortmund", coordinate: .init(latitude: 51.5136, longitude: 7.4653)),
        MKMapItem(name: "Essen", coordinate: .init(latitude: 51.4556, longitude: 7.0116)),
        MKMapItem(name: "Bremen", coordinate: .init(latitude: 53.0793, longitude: 8.8017)),
        MKMapItem(name: "Dresden", coordinate: .init(latitude: 51.0504, longitude: 13.7373)),
        MKMapItem(name: "Hanover", coordinate: .init(latitude: 52.3759, longitude: 9.732)),
        MKMapItem(name: "Nurenberg", coordinate: .init(latitude: 49.4521, longitude: 11.0767)),
        MKMapItem(name: "Duisburg", coordinate: .init(latitude: 51.4344, longitude: 6.7623)),
        MKMapItem(name: "Bochum", coordinate: .init(latitude: 51.4818, longitude: 7.2162)),
        MKMapItem(name: "Wuppertal", coordinate: .init(latitude: 51.2562, longitude: 7.1508)),
        MKMapItem(name: "Bonn", coordinate: .init(latitude: 50.7374, longitude: 7.0982)),
        MKMapItem(name: "Munster", coordinate: .init(latitude: 51.9607, longitude: 7.6261)),
        MKMapItem(name: "Mannheim", coordinate: .init(latitude: 49.4875, longitude: 8.466)),
        MKMapItem(name: "Karlsruhe", coordinate: .init(latitude: 49.0069, longitude: 8.4037)),
        MKMapItem(name: "Augsburg", coordinate: .init(latitude: 48.3705, longitude: 10.8978)),
        MKMapItem(name: "Wiesbaden", coordinate: .init(latitude: 50.0782, longitude: 8.2398)),
        MKMapItem(name: "Mönchengladbach", coordinate: .init(latitude: 51.1942, longitude: 6.4315))
    ]),
    PlaceGroup(name: "Test Germany", places: [
        MKMapItem(name: "Berlin", coordinate: .init(latitude: 52.52, longitude: 13.405)),
        MKMapItem(name: "Hamburg", coordinate: .init(latitude: 53.5488, longitude: 9.9872)),
        MKMapItem(name: "Munich", coordinate: .init(latitude: 48.1351, longitude: 11.582)),
        MKMapItem(name: "Frankfurt", coordinate: .init(latitude: 50.1109, longitude: 8.6821)),
        MKMapItem(name: "Stuttgart", coordinate: .init(latitude: 48.7758, longitude: 9.1829)),
        MKMapItem(name: "Leipzig", coordinate: .init(latitude: 51.3397, longitude: 12.3731)),
        MKMapItem(name: "Dortmund", coordinate: .init(latitude: 51.5136, longitude: 7.4653)),
        MKMapItem(name: "Hanover", coordinate: .init(latitude: 52.3759, longitude: 9.732)),
        MKMapItem(name: "Nurenberg", coordinate: .init(latitude: 49.4521, longitude: 11.0767)),
        MKMapItem(name: "Duisburg", coordinate: .init(latitude: 51.4344, longitude: 6.7623)),
        MKMapItem(name: "Bonn", coordinate: .init(latitude: 50.7374, longitude: 7.0982)),
    ]),
    PlaceGroup(name: "Japan", places: [
        MKMapItem(name: "Tokyo", coordinate: .init(latitude: 35.6764, longitude: 139.65)),
        MKMapItem(name: "Yokohama", coordinate: .init(latitude: 35.4437, longitude: 139.638)),
        MKMapItem(name: "Osaka", coordinate: .init(latitude: 34.6937, longitude: 135.5023)),
        MKMapItem(name: "Nagoya", coordinate: .init(latitude: 35.1815, longitude: 136.9066)),
        MKMapItem(name: "Sapporo", coordinate: .init(latitude: 43.0618, longitude: 141.3545)),
        MKMapItem(name: "Kobe", coordinate: .init(latitude: 34.6901, longitude: 135.1956)),
        MKMapItem(name: "Kyoto", coordinate: .init(latitude: 35.0116, longitude: 135.7681)),
        MKMapItem(name: "Fukuoka", coordinate: .init(latitude: 35.5902, longitude: 130.4017)),
        MKMapItem(name: "Kawasaki", coordinate: .init(latitude: 35.5308, longitude: 139.7029)),
        MKMapItem(name: "Saitama", coordinate: .init(latitude: 35.8616, longitude: 139.6455)),
        MKMapItem(name: "Hiroshima", coordinate: .init(latitude: 34.3853, longitude: 132.4553)),
        MKMapItem(name: "Yono", coordinate: .init(latitude: 35.88333, longitude: 139.6333)),
        MKMapItem(name: "Sendai", coordinate: .init(latitude: 38.2682, longitude: 140.8694)),
        MKMapItem(name: "Kitakyushu", coordinate: .init(latitude: 33.8835, longitude: 130.8752)),
        MKMapItem(name: "Chiba", coordinate: .init(latitude: 35.6074, longitude: 140.1065)),
        MKMapItem(name: "Sakai", coordinate: .init(latitude: 34.5733, longitude: 135.4831)),
        MKMapItem(name: "Shizuoka", coordinate: .init(latitude: 34.9756, longitude: 138.3827)),
        MKMapItem(name: "Kumamoto", coordinate: .init(latitude: 32.8032, longitude: 130.7079)),
        MKMapItem(name: "Okayama", coordinate: .init(latitude: 34.6555, longitude: 133.9198)),
        MKMapItem(name: "Hamamatsu", coordinate: .init(latitude: 34.7103, longitude: 137.7374)),
        MKMapItem(name: "Hachioji", coordinate: .init(latitude: 35.6664, longitude: 139.316)),
        MKMapItem(name: "Honcho", coordinate: .init(latitude: 35.70129, longitude: 139.98648)),
        MKMapItem(name: "Kagoshima", coordinate: .init(latitude: 31.5969, longitude: 130.5571)),
        MKMapItem(name: "Niigata", coordinate: .init(latitude: 37.9161, longitude: 139.0364)),
        MKMapItem(name: "Himeji", coordinate: .init(latitude: 34.8154, longitude: 134.6856))
    ])
    /*,
    PlaceGroup(name: "Japan", places: [
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>))
    ]),
    PlaceGroup(name: "Japan", places: [
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>))
    ]),
    PlaceGroup(name: "Japan", places: [
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)),
        MKMapItem(name: <#T##String#>, coordinate: .init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>))
    ]) */
] // Add place groups here
