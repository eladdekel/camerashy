//
//  CallingHandlers.swift
//  CameraShy
//
//  Created by Elad Dekel on 2021-02-20.
//

import Foundation
import Alamofire


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

            DispatchQueue.main.async {
                let dataDataDict:[String: String] = ["gameId": responses.gameId]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "gameID"), object: nil, userInfo: dataDataDict)

            }
        
    }
    
    
   
    }
    
    
}
