//
//  GameMechVC.swift
//  CameraShy
//
//  Created by Elad Dekel on 2021-02-20.
//

import UIKit
import CoreLocation
import SwiftLocation
import MapKit

protocol GameEndedDelegate {
    func gameEnded(_ players: Double,_ time: String,_ kills: Double)
}

class GameMechVC: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var playerNumber: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!
    var trueLocation: GPSLocationRequest.ProducedData?
    var Users: [User] = []
    var seconds: Double = 0
    var isTimerRunning = false
    var timer = Timer()
    var delegate: GameEndedDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        mapView.showsUserLocation = true
        mapView.delegate = self
        countdownLabel.text = "\(timeString(time: seconds))"

        
        // RUN SET LOCATION WITH THE DATA
        // START PLOTTING USERS
    }
    
    // MARK: - Updates UI
    
    func updateUI() {
        bottomView.backgroundColor = UIColor(named: "MediumBlue")
        topView.backgroundColor = UIColor(named: "MediumBlue")
        topView.layer.cornerRadius = 20
        bottomView.roundCorners(corners: .topLeft, radius: 20)
        bottomView.roundCorners(corners: .topRight, radius: 20)
    }
    
    // MARK: - Plots Users
    
    func plotUsers() {
        for user in Users {
            
            for x in mapView.annotations {
                if x.title == "\(user.name)" {
                    mapView.removeAnnotation(x)
                }
            }
            let playerPoint = MKPointAnnotation()
            playerPoint.title = "\(user.name)"
            playerPoint.coordinate = user.location
            mapView.addAnnotation(playerPoint)
        }
    
        
        playerNumber.text = "\(Users.count)"
        
    }
    
    // MARK: - Draws Radius
   
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.red
            circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
            circle.lineWidth = 1
            return circle
        } else {
            return MKPolylineRenderer()
        }
    }
    
    func circle(_ location: CLLocationCoordinate2D, _ radius: Double) {
        let circle = MKCircle(center: location, radius: radius)
        mapView.addOverlay(circle)
    }
    
    // MARK: - Sets the Map Location
    
    func setLocation(_ location: CLLocationCoordinate2D, _ boundaries: MKCoordinateSpan, _ radius: Double) {
        let coordinate = location
        let span = MKCoordinateSpan(latitudeDelta: boundaries.latitudeDelta, longitudeDelta: boundaries.longitudeDelta)
        
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
        mapView.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: true)
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 3000)
        
        mapView.setCameraZoomRange(zoomRange, animated: true)
       
        circle(coordinate, radius)
        
        
        
    }
    
    // MARK: - Formats Timer
    
    func timeString(time:TimeInterval) -> String {
    let hours = Int(time) / 3600
    let minutes = Int(time) / 60 % 60
    let seconds = Int(time) % 60
    return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    @objc func updateTimer() {
        seconds -= 1
        countdownLabel.text = "\(timeString(time: seconds))"
        
    }
    
    // MARK: - Game Began Function
    
    func gameBegan(location: CLLocationCoordinate2D, boundaries: MKCoordinateSpan, radius: Double, time: Double, playerCount: Double) {
        
        setLocation(location, boundaries, radius)
        
         seconds = time
        // SET TIMER
        if timer.isValid == true {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        }
        
        // SET PLAYER COUNT
        playerNumber.text = "\(playerCount)"

        
        // SET GEOFENCE
        
        let options = GeofencingOptions(circleWithCenter: location, radius: radius)
        
        SwiftLocation.geofenceWith(options).then { (result) in
            guard let event = result.data else{ return }
            
            switch event {
            case .didEnteredRegion(let r):
               print("good, \(r) is in region")
                // SEND LOCATION TO SERVER
                
            case .didExitedRegion(let r):
                print("left the region!")
                
            // SEND MESSAGE TO SERVER
            // REMOVE FROM GAME
                
            default:
                break
    
            }
        }
  
        
    }
    
    
    // MARK: - GameUpdated Func
    
    func gameUpdate(players: Double, time: Double) {
        
        
        
    }
    
 


// MARK: - PlayerLoss

func playerLoss() {
    // TELLS THEM THEY LOST, THEIR PLACE, TIME, KILLS
 
    
 //   delegate?.gameEnded(players, timeString(time: seconds), kills)
   dismiss(animated: true)
    
    
}
}

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}