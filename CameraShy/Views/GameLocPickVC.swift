//
//  GameLocPickVC.swift
//  CameraShy
//
//  Created by Elad Dekel on 2021-02-19.
//

import UIKit
import MapKit
import CoreLocation
import SwiftLocation

protocol PassingDataBack {
    func sendData(_ cords: CLLocationCoordinate2D, _ zoom: MKCoordinateSpan, _ range: CLLocationDistance)
}

class GameLocPickVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var doneButton: UIButton!
    let locationManager = CLLocationManager()
    @IBOutlet weak var radiusSlider: UISlider!
    var trueLocation: GPSLocationRequest.ProducedData?
    @IBOutlet weak var errorLabel: UILabel!
    var delegate: PassingDataBack?
    var chosenLocation: CLLocationCoordinate2D?
    var backupRadius: Float = 100
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        doneButton.layer.cornerRadius = 20
        locationManager.delegate = self
        radiusSlider.minimumValue = 100
        radiusSlider.maximumValue = 3000
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        addRegion()
        mapView.delegate = self
        locationManager.startUpdatingLocation()
        setMapview()
        doneButton.setTitle("Select", for: .normal)
        errorLabel.text = "Hold your finger on the spot you wish to be the centre of the game. Then, use the slider to select an arena size."

    }
    
    // MARK: - Completed Button
    
    @IBAction func doneButtonPress(_ sender: Any) {
        
        
        if mapView.overlays.isEmpty == true {
            errorLabel.text = "Please select an area."
            
            
        } else {
            
            
            let zoom = mapView.region.span
            let coordinates = chosenLocation!
            if let overpls = mapView.overlays[0] as? MKCircle {
                print(overpls.radius)
                delegate?.sendData(coordinates, zoom, overpls.radius)
            } else {
                delegate?.sendData(coordinates, zoom, CLLocationDistance(backupRadius))
                
            }
            
            dismiss(animated: true)

            
        }
    }
    
    // MARK: - Monitors if they Press on Map
    
    func setMapview(){
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureReconizer:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.mapView.addGestureRecognizer(lpgr)
    }
    
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizer.State.ended {
            let touchLocation = gestureReconizer.location(in: mapView)
            let locationCoordinate = mapView.convert(touchLocation,toCoordinateFrom: mapView)
            chosenLocation = locationCoordinate
            let overlays = mapView.overlays
            for overlay in overlays {
                mapView.removeOverlay(overlay)
                
                
            }
            addAnnotation(lat: locationCoordinate.latitude, long: locationCoordinate.longitude)
            
            
            return
        }
        if gestureReconizer.state != UIGestureRecognizer.State.began {
            return
        }
    }
    
    func addAnnotation(lat: Double, long: Double) {
        for x in mapView.annotations {
            mapView.removeAnnotation(x)
            
        }
        
        let playerPoint = MKPointAnnotation()
        playerPoint.title = "Centre"
        playerPoint.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        mapView.addAnnotation(playerPoint)
        
        
    }
    
    // MARK: - Draws the Radius
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.red
            circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
            circle.lineWidth = 1
            print(circle)
            return circle
        } else {
            return MKPolylineRenderer()
        }
    }
    
    func circle(_ radius: Double) {
        let circle = MKCircle(center: trueLocation!.coordinate, radius: radius)
        mapView.addOverlay(circle)
    }
    
    @IBAction func radiusSlide(_ sender: Any) {
        if chosenLocation != nil {
            
            let overlays = mapView.overlays
            for overlay in overlays {
                mapView.removeOverlay(overlay)
                
                
            }
            backupRadius = radiusSlider.value
            let circle = MKCircle(center: CLLocationCoordinate2D(latitude: chosenLocation!.latitude, longitude: chosenLocation!.longitude), radius: CLLocationDistance(radiusSlider.value/2))
            mapView.addOverlay(circle)
        } else {
            errorLabel.text = "Please select a centre location."
            
        }
    }
    
    // MARK: - Checks for their location
    
    func addRegion() {
        SwiftLocation.gpsLocation().then { (result) in
            switch result {
            case .success(let newData):
                
                DispatchQueue.main.async {
                    self.trueLocation = newData
                }
            case .failure(let error):
                print(error.localizedDescription)
                
                
            }
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingHeading()
            render(location)
            
            
            
        }
    }
    
    // MARK: - Draws the map based on their location
    
    func render (_ location: CLLocation) {
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        
        
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 3000)
        mapView.setCameraZoomRange(zoomRange, animated: true)
        
        
        
    }
    
    
    
}

private extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 1000
    ) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
