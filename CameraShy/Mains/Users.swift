//
//  Users.swift
//  CameraShy
//
//  Created by Elad Dekel on 2021-02-20.
//

import Foundation
import MapKit

struct User {
    var name: String
    var location: CLLocationCoordinate2D
}



struct GeoData {
    let lat: Float
    let long: Float
    let rad: Float
    let bound: [Float]
    
    
}


struct Again {
    let cords: CLLocationCoordinate2D
    let zoom: MKCoordinateSpan
    let range: CLLocationDistance

    
}


struct JSONBack: Decodable {
    let loc: [Float]
    let id: String
    let gameId: String
    
    
}

struct responseWin: Decodable {
    let status: Int
    let message: String
    
    
}
