//
//  ViewController.swift
//  CameraShy
//
//  Created by Elad Dekel on 2021-02-19.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    let locationManager = CLLocationManager()

    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestWhenInUseAuthorization()

        // Do any additional setup after loading the view.
    }


}

