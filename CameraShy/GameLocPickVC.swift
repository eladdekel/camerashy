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
    func sendData(_ cords: CLLocationCoordinate2D)
}

class GameLocPickVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var doneButton: UIButton!
    let locationManager = CLLocationManager()
    var trueLocation: GPSLocationRequest.ProducedData?
    var delegate: PassingDataBack?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        addRegion()
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func doneButtonPress(_ sender: Any) {
        let coordinates = mapView.centerCoordinate
        delegate?.sendData(coordinates)
        dismiss(animated: true)
        
        
        
        
    }
    
    
    // THE CODE BELOW IS SETTING THE GEOFENCE TO WHERE THEY ARE RIGHT NOW, JUST NEED TO CHANGE THAT TO SET IT TO THE LAT/LONG OF WHERE IT WILL START
//    if trueLocation != nil {
//    let options = GeofencingOptions(circleWithCenter: CLLocationCoordinate2D(latitude: trueLocation!.coordinate.latitude, longitude: trueLocation!.coordinate.longitude), radius: 3000)
//
//        SwiftLocation.geofenceWith(options).then { (result) in
//            guard let event = result.data else{ return }
//
//            switch event {
//            case .didEnteredRegion(let r):
//                print("entered the region!")
//            case .didExitedRegion(let r):
//                print("left the region!")
//            default:
//                break
//
//
//            }
//        }
//    }
    

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
