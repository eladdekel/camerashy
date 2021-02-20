//
//  GameSettingsVC.swift
//  CameraShy
//
//  Created by Elad Dekel on 2021-02-19.
//

import UIKit
import MapKit

class GameSettingsVC: UIViewController, PassingDataBack {

    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var gameTitle: UILabel!
    
    @IBOutlet weak var timeTitle: UILabel!
    @IBOutlet weak var timeLimitLabel: UILabel!
    @IBOutlet weak var timeStepper: UIStepper!
    @IBOutlet weak var gameNameLabel: UILabel!
    
    
    @IBOutlet weak var playerTitle: UILabel!
    @IBOutlet weak var playerLimitLabel: UILabel!
    @IBOutlet weak var playerStepper: UIStepper!
    
    
    @IBOutlet weak var mapTitle: UILabel!
    @IBOutlet weak var mapView: UIView!
    
    
    var codesForGeo: CLLocationCoordinate2D?
    var gameName: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        UISetup()

        
    }
    
    func UISetup() {
        mainView.backgroundColor = UIColor(named: "MediumBlue")
        mapView.layer.cornerRadius = 20
        gameTitle.text = gameName
        gameTitle.textAlignment = .center
        playerStepper.value = 3
        timeStepper.value = 1
        playerStepper.minimumValue = 3
        timeStepper.minimumValue = 1
        timeStepper.maximumValue = 120
        playerStepper.maximumValue = 50
        playerLimitLabel.text = "\(Int(playerStepper.value)) players"
        timeLimitLabel.text = "\(Int(timeStepper.value)) minute"
        let mapTapped = UITapGestureRecognizer(target: self, action: #selector(mapTappedFunc(gesture:)))
        mapView.addGestureRecognizer(mapTapped)
        mapView.isUserInteractionEnabled = true
    }
    
    @IBAction func timeStepperAction(_ sender: Any) {
        if timeStepper.value > 1 {
            timeLimitLabel.text = "\(Int(timeStepper.value)) minutes"
            
        } else if timeStepper.value == 1 {
        
        timeLimitLabel.text = "\(Int(timeStepper.value)) minute"
        }
        
    }
    
    @IBAction func playerStepperAction(_ sender: Any) {
        playerLimitLabel.text = "\(Int(playerStepper.value)) players"

    }
    
    @objc func mapTappedFunc(gesture: UITapGestureRecognizer) {
        performSegue(withIdentifier: "toMap", sender: nil)
        
        
    }
    
    func sendData(_ cords: CLLocationCoordinate2D) {
        mapView.backgroundColor = .blue
        print(cords)
    }
    
    
    @IBAction func doneButton(_ sender: Any) {
        if codesForGeo != nil {
            // SAVE AND SEND DATA TO SERVER
            
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMap" {
            let destVC = segue.destination as! GameLocPickVC
            destVC.delegate = self
            
            
        }
    }

}
