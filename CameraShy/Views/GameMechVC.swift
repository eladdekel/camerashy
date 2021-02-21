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
import SwiftUI

protocol GameEndedDelegate {
    func gameEnded(_ players: Double,_ time: String,_ kills: Double)
}

class GameMechVC: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var getLocButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var leaveButton: UIButton!
    @IBOutlet weak var playerNumber: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var backViewBigLabel: UILabel!
    @IBOutlet weak var backViewSecondLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var countdownLabel: UILabel!
    var seconds: Double = 0
    var isTimerRunning = false
    var timer = Timer()
    var timer2 = Timer()
    var delegate: GameEndedDelegate?
    var regionMaster: MKCoordinateRegion?
    let call = CallingHandlers()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        mapView.showsUserLocation = true
        mapView.delegate = self
        countdownLabel.text = "\(timeString(time: seconds))"
        prepSwiftUI()
        NotificationCenter.default.addObserver(self, selector: #selector(loadKills), name: NSNotification.Name(rawValue: "headShot"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(plotUsers), name: NSNotification.Name(rawValue: "userUpdates"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gameInfoFunc), name: NSNotification.Name(rawValue: "gameInfo"), object: nil)



        // RUN SET LOCATION WITH THE DATA
        // START PLOTTING USERS
    }
    
    // MARK: - Updates UI
    
    func prepSwiftUI() {
        let childView = UIHostingController(rootView: CameraButton())
        addChild(childView)
        childView.view.frame = containerView.bounds
        childView.view.backgroundColor = .clear
        containerView.addSubview(childView.view)
        childView.didMove(toParent: self)
        
    }
    
    
    func updateUI() {
        bottomView.backgroundColor = UIColor(named: "MediumBlue")
        topView.backgroundColor = UIColor(named: "MediumBlue")
        topView.layer.cornerRadius = 20
        bottomView.layer.cornerRadius = 20
        bottomView.layer.opacity = 0.9
        
        topView.layer.opacity = 0.9
        self.getLocButton.setImage(UIImage(systemName: "location"), for: .normal)
        leaveButton.setImage(UIImage(systemName: "hand.raised.slash"), for: .normal)
        
        
        backView.alpha = 0

    }
    
    override func viewDidAppear(_ animated: Bool) {
        var aID: String?
        
        if let appleID = UserDefaults().string(forKey: "AppleInfoUser") {
            aID = appleID
            
        }
        
        SwiftLocation.gpsLocation().then { (result) in
            switch result {
            case .success(let newData):
                
                DispatchQueue.main.async {
                    let tester: OccPost = OccPost(gameId: Singleton.shared.gameID!, appleId: aID!, loc: LatLong(lat: newData.coordinate.latitude, long: newData.coordinate.longitude))
                    self.call.occasionalPost(tester)
                }
            case .failure(let error):
                print(error.localizedDescription)
                
                
            }
        }
        
      
    }
    
    // MARK: - Plots Users
    
    @objc func plotUsers(notification: NSNotification) {
        if let filebrought = notification.userInfo?["userUpdates"] as? [LatLong] {
        
        
        for user in filebrought {
            
            for x in mapView.annotations {
                    mapView.removeAnnotation(x)
            }
            
            let playerPoint = MKPointAnnotation()
            playerPoint.coordinate = CLLocationCoordinate2D(latitude: user.lat, longitude: user.long)
            mapView.addAnnotation(playerPoint)
        }
        
        
        playerNumber.text = "\(filebrought.count)"
        
        } else {
            print("error in plotting users")
            
            
        }
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
    
    @objc func gameInfoFunc(notification: NSNotification) {
            if let filebrought = notification.userInfo?["gameInfo"] as? GameCreator {
            
                let location = CLLocationCoordinate2D(latitude: Double(filebrought.gfence.lat), longitude: Double(filebrought.gfence.long))
                let boundaries = MKCoordinateSpan(latitudeDelta: Double(filebrought.gfence.bound[0]), longitudeDelta: Double(filebrought.gfence.bound[1]))
                
                gameBegan(location: location, boundaries: boundaries, radius: Double(filebrought.gfence.rad), time: Double(filebrought.time), playerCount: Double(filebrought.numPlayers))
                
                
            } else {
                
                print("error getting game starting data")
            }
        
        
    }
    
    
    
    
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
                DispatchQueue.main.async {
                    self.playerLoss()
            // SEND MESSAGE TO SERVER
            // REMOVE FROM GAME
                }
                    
            default:
                break
                
            }
        }
        
        
        regionMaster = MKCoordinateRegion(center: location, span: boundaries)
    }
    
    
    // MARK: - GameUpdated Func
    
    @objc func loadKills(notification: NSNotification) {
        if let results = notification.userInfo?["data"] as? Int {
            switch results {
            case 1:
                // KILL
                backView.backgroundColor = UIColor(named: "OrangeColor")
                backViewBigLabel.text = "Nice Shot!"
                backViewSecondLabel.text = "You caught them!"
                
            case 0:
                // MISS
                backView.backgroundColor = UIColor(named: "TextColor")
                backViewBigLabel.text = "Uh Oh!"
                backViewSecondLabel.text = "Your attempt was unsuccessful."
            default:
               break
            }
            
            backView.alpha = 1
            timer2 = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(hideTheView), userInfo: nil, repeats: false)
            
        } else {
            print("error loading hitshot data")
            
        }
    }
    
    
    @objc func hideTheView() {
        UIView.animate(withDuration: 2) {
            self.backView.alpha = 0
        }
        
        
    }
    
    
    func gameUpdate(players: Double, time: Double) {
        
        
        
    }
    
    @IBAction func getLocation(_ sender: UIButton) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        if sender.currentImage == UIImage(systemName: "location") {
            
            SwiftLocation.gpsLocation().then { (result) in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let loc):
                    DispatchQueue.main.async {
                        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
                        
                        self.mapView.setRegion(region, animated: true)
                        self.getLocButton.setImage(UIImage(systemName: "person.2"), for: .normal)
                        
                    }
                }
            }
        } else {
            
            if regionMaster != nil {
                mapView.setRegion(regionMaster!, animated: true)
                
                self.getLocButton.setImage(UIImage(systemName: "location"), for: .normal)
            } else {
                self.getLocButton.setImage(UIImage(systemName: "location"), for: .normal)
                
                
                
            }
        }
    }
    
    @IBAction func leaveButton(_ sender: Any) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        let alertController = UIAlertController(title: "Leave Game", message: "Are you sure you would like to leave the game? This cannot be undone.", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Leave", style: .destructive) { (_) -> Void in
            
            self.dismiss(animated: true) {
                self.call.onPlayerLeave()
                
            }
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
            
            
        }
        
        
        
    }
    
    
    // MARK: - PlayerLoss
    
    func playerLoss() {
        // TELLS THEM THEY LOST, THEIR PLACE, TIME, KILLS
      
 //       delegate?.gameEnded(players, timeString(time: seconds), kills)
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
