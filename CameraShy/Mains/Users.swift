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


struct gameID: Decodable {
    let gameId: String
    
}


struct GameCreator: Decodable {
    let appleId: String
    let numPlayers: Float
    let time: Float
    let gfence: GeoFence
    
    
    
}


struct GeoFence: Decodable {
    let lat: Float
    let long: Float
    let rad: Float
    let bound: [Float]
    
    
    
}


struct OccPost: Decodable {
    let gameId: String
    let appleId: String
    let loc: LatLong
    
    
}

struct LatLong: Decodable {
    let lat: Double
    let long: Double
    
}

struct GameData: Decodable {
    let game: TrueGame
    let numPlayers: Double
    
    
}

struct TrueGame: Decodable {
    let bound: [Double]
    let id: String
    let lat: Double
    let long: Double
    let memberLimit: Double
    let timeLimit: Double
    let players: [Players]
    
    
}

struct Players: Decodable {
    let _id: String
    let imageUrl: String
    let personId: String
    let osId: String
    
    
}
