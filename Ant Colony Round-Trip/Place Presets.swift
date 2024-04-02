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
        MKMapItem(name: "Munster", coordinate: .init(latitude: 51.9607, longitude: 7.6261))
    ]),
    PlaceGroup(name: "Japan", places: [
        MKMapItem(name: "Tokyo", coordinate: .init(latitude: 35.6764, longitude: 139.65)),
        MKMapItem(name: "Yokohama", coordinate: .init(latitude: 35.4437, longitude: 139.638)),
        MKMapItem(name: "Osaka", coordinate: .init(latitude: 34.6937, longitude: 135.5023)),
        MKMapItem(name: "Nagoya", coordinate: .init(latitude: 35.1815, longitude: 136.9066)),
        MKMapItem(name: "Kyoto", coordinate: .init(latitude: 35.0116, longitude: 135.7681)),
        MKMapItem(name: "Fukuoka", coordinate: .init(latitude: 35.5902, longitude: 130.4017)),
        MKMapItem(name: "Kawasaki", coordinate: .init(latitude: 35.5308, longitude: 139.7029)),
        MKMapItem(name: "Saitama", coordinate: .init(latitude: 35.8616, longitude: 139.6455)),
        MKMapItem(name: "Hiroshima", coordinate: .init(latitude: 34.3853, longitude: 132.4553)),
        MKMapItem(name: "Yono", coordinate: .init(latitude: 35.88333, longitude: 139.6333)),
        MKMapItem(name: "Sendai", coordinate: .init(latitude: 38.2682, longitude: 140.8694)),
        MKMapItem(name: "Kitakyushu", coordinate: .init(latitude: 33.8835, longitude: 130.8752)),
        MKMapItem(name: "Chiba", coordinate: .init(latitude: 35.6074, longitude: 140.1065)),
        MKMapItem(name: "Shizuoka", coordinate: .init(latitude: 34.9756, longitude: 138.3827)),
        MKMapItem(name: "Kumamoto", coordinate: .init(latitude: 32.8032, longitude: 130.7079)),
        MKMapItem(name: "Okayama", coordinate: .init(latitude: 34.6555, longitude: 133.9198)),
        MKMapItem(name: "Hamamatsu", coordinate: .init(latitude: 34.7103, longitude: 137.7374)),
        MKMapItem(name: "Hachioji", coordinate: .init(latitude: 35.6664, longitude: 139.316)),
        MKMapItem(name: "Niigata", coordinate: .init(latitude: 37.9161, longitude: 139.0364)),
        MKMapItem(name: "Himeji", coordinate: .init(latitude: 34.8154, longitude: 134.6856))
    ]),
    PlaceGroup(name: "United States", places: [
        MKMapItem(name: "New York City", coordinate: .init(latitude: 40.71427, longitude: -74.00597)),
        MKMapItem(name: "Los Angeles", coordinate: .init(latitude: 34.05223, longitude: -118.24368)),
        MKMapItem(name: "Chicago", coordinate: .init(latitude: 41.85003, longitude: -87.65005)),
        MKMapItem(name: "Houston", coordinate: .init(latitude: 29.76328, longitude: -95.36327)),
        MKMapItem(name: "Phoenix", coordinate: .init(latitude: 33.448376, longitude: -112.074036)),
        MKMapItem(name: "Philadelphia", coordinate: .init(latitude: 39.95233, longitude: -75.16379)),
        MKMapItem(name: "San Antonio", coordinate: .init(latitude: 29.424349, longitude: -98.491142)),
        MKMapItem(name: "San Diego", coordinate: .init(latitude: 32.71571, longitude: -117.16472)),
        MKMapItem(name: "Dallas", coordinate: .init(latitude: 32.78306, longitude: -96.80667)),
        MKMapItem(name: "Jacksonville", coordinate: .init(latitude: 30.332184, longitude: -81.655647)),
        MKMapItem(name: "Fort Worth", coordinate: .init(latitude: 32.768799, longitude: -97.309341)),
        MKMapItem(name: "Austin", coordinate: .init(latitude: 30.266666, longitude: -97.73333)),
        MKMapItem(name: "San Jose", coordinate: .init(latitude: 37.33939, longitude: -121.89496)),
        MKMapItem(name: "Charlotte", coordinate: .init(latitude: 35.227085, longitude: -80.843124)),
        MKMapItem(name: "Columbus", coordinate: .init(latitude: 39.983334, longitude: -82.98333)),
        MKMapItem(name: "Indianapolis", coordinate: .init(latitude: 39.791, longitude: -86.148)),
        MKMapItem(name: "Seattle", coordinate: .init(latitude: 47.608013, longitude: -122.335167)),
        MKMapItem(name: "San Francisco", coordinate: .init(latitude: 37.773972, longitude: -122.431297)),
        MKMapItem(name: "Denver", coordinate: .init(latitude: 39.742043, longitude: -104.99153)),
        MKMapItem(name: "Oklahoma", coordinate: .init(latitude: 35.46756, longitude: -96.5164276))
    ])
] // Add place groups here
