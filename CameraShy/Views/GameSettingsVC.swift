//
//  GameSettingsVC.swift
//  CameraShy
//
//  Created by Elad Dekel on 2021-02-19.
//

import UIKit
import MapKit
import Alamofire

class GameSettingsVC: UIViewController, PassingDataBack {

    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var gameTitle: UILabel!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var timeBack: UIView!
    @IBOutlet weak var timeTitle: UILabel!
    @IBOutlet weak var timeLimitLabel: UILabel!
    @IBOutlet weak var timeStepper: UIStepper!
    @IBOutlet weak var gameNameLabel: UILabel!
    
    
    @IBOutlet weak var playerBack: UIView!
    @IBOutlet weak var playerTitle: UILabel!
    @IBOutlet weak var playerLimitLabel: UILabel!
    @IBOutlet weak var playerStepper: UIStepper!
    
    
    @IBOutlet weak var mapBack: UIView!
    @IBOutlet weak var mapTitle: UILabel!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var mapKitV: MKMapView!
    
    
    @IBOutlet weak var doneButton: UIButton!
    var codesForGeo: CLLocationCoordinate2D?
    var gameName: String = ""
    var geoGo: Again?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UISetup()

        
    }
    
    func UISetup() {
        self.navigationController?.isNavigationBarHidden = true

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
        mapView.backgroundColor = UIColor.clear
        mapKitV.layer.cornerRadius = 20
        playerStepper.backgroundColor = UIColor(named: "ButtonColor")
        timeStepper.backgroundColor = UIColor(named: "ButtonColor")
        doneButton.layer.cornerRadius = 20
        mapKitV.isUserInteractionEnabled = false
        errorLabel.text = ""
        
        if Singleton.shared.teamName != nil {
            gameNameLabel.text = Singleton.shared.teamName
            
        } else {
            gameNameLabel.text = "Settings"
            
        }
        
        
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
    
    func sendData(_ cords: CLLocationCoordinate2D, _ zoom: MKCoordinateSpan, _ range: CLLocationDistance) {
        mapView.backgroundColor = .blue
        print(cords)
        print(zoom)
        print(range)
        
        
        let test = Again(cords: cords, zoom: zoom, range: range)
        geoGo = test
   
    }
    
    func checkApple() -> String {
        
        return("test")
    }
    
    
    @IBAction func doneButton(_ sender: Any) {
        if geoGo != nil {
            // SAVE AND SEND DATA TO SERVER
            
            let parameters: Parameters = [
                "appleId": checkApple(),
                "numPlayers": playerStepper.value,
                "time": "\(timeStepper.value)",
                "Timestamp": "",
                "gfence": [
                    "lat":geoGo!.cords.latitude,
                    "long":geoGo!.cords.longitude,
                    "rad":geoGo!.range,
                    "bound":[geoGo!.zoom.latitudeDelta, geoGo?.zoom.longitudeDelta]
                ]
                
             ]

            
            AF.request("http://camera-shy.space/api/createGame", method: .post, parameters: parameters).response {
                response in
                print(response)
                
            }
            // CALL THE NEXT VIEW WITH THE NEW DATA
            // DISMISS?
            
            
        } else {
            errorLabel.text = "Please select a location."
            
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMap" {
            let destVC = segue.destination as! GameLocPickVC
            destVC.delegate = self
            
            
        }
    }

}