//
//  ViewController.swift
//  CameraShy
//
//  Created by Elad Dekel on 2021-02-19.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, GameEndedDelegate {

    
    
    let locationManager = CLLocationManager()

    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestWhenInUseAuthorization()

        // Do any additional setup after loading the view.
    }

    func gameEnded(_ players: Double, _ time: String, _ kills: Double) {
        // PRESENT WITH INFO
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gameBegan" {
            let destvc = segue.destination as! GameMechVC
            destvc.delegate = self
            
            
        }
    }
    
}

