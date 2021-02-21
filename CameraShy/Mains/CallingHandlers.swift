//
//  CallingHandlers.swift
//  CameraShy
//
//  Created by Elad Dekel on 2021-02-20.
//

import Foundation
import Alamofire
import SwiftLocation
import MapKit
import CoreLocation


class CallingHandlers {
    
    
    func createGame(_ data: GameCreator) {
        
        var aID: String?
        
        if let appleID = UserDefaults().string(forKey: "AppleInfoUser") {
            aID = appleID
            
        }
        
        let parameters: Parameters = [
            "appleId": aID!,
            "numPlayers": data.numPlayers,
            "time": "\(data.time)",
            "gfence": [
                "lat":data.gfence.lat,
                "long":data.gfence.long,
                "rad":data.gfence.rad,
                "bound":data.gfence.bound
            ]
            
         ]

        
        AF.request("http://camera-shy.space/api/createGame", method: .post, parameters: parameters).validate().responseDecodable(of: gameID.self) { (response) in
            guard let responses = response.value else { return }
            print(responses.gameId)
            Singleton.shared.gameID = responses.gameId

            DispatchQueue.main.async {
                let dataDataDict:[String: String] = ["gameId": responses.gameId]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hostGameStart"), object: nil, userInfo: dataDataDict)

            }
        
    }
    
    
   
    }
    
    
    func occasionalPost(_ data: OccPost) {
        
        var aID: String?

        if let appleID = UserDefaults().string(forKey: "AppleInfoUser") {
            aID = appleID
            
        }
        
        let parameters: Parameters = [
            "gameId":data.gameId,
            "appleId": aID!,
            "loc":[
                "lat":data.loc.lat,
                "long:":data.loc.long
            ]
            
         ]

        
        AF.request("http://camera-shy.space/api/loc", method: .post, parameters: parameters).validate().responseDecodable(of: [LatLong].self) { (response) in
            guard let responses = response.value else { return }
            print(responses)

            DispatchQueue.main.async {
               let dataDataDict:[String: [LatLong]] = ["userUpdates": responses]
               NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userUpdates"), object: nil, userInfo: dataDataDict)

            }
        
    }
    
        
        
    }
    
   
    func onPlayerJoin(_ gameID: String) {
        var aID: String?
        
        if let appleID = UserDefaults().string(forKey: "AppleInfoUser") {
            aID = appleID
            
        }
        
        let parameters: Parameters = [
            "appleId": aID!,
            "gameId": "dOEcP"
            ]
            


        
        AF.request("http://camera-shy.space/api/join", method: .post, parameters: parameters).responseJSON { (test) in
            print(test.data)
        }
            
        }
        
        
        
        
        
//        validate().responseDecodable(of: gameID.self) { (response) in
//            guard let responses = response.value else { return }
//            print(responses.gameId)
//            Singleton.shared.gameID = responses.gameId
//
//            DispatchQueue.main.async {
//                let dataDataDict:[String: String] = ["gameId": responses.gameId]
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "gameID"), object: nil, userInfo: dataDataDict)
//
//            }
//
//    }
        
        
        
    
    
    
}
