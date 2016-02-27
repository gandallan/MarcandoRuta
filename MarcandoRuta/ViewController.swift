//
//  ViewController.swift
//  MarcandoRuta
//
//  Created by Gandhi Mena Salas on 24/02/16.
//  Copyright © 2016 Trenx. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import MapKit
import AddressBook

class ViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
//*************Outlets

    @IBOutlet weak var mapa: MKMapView!
    
    
//*************Variables
    //location
    var latitude: CLLocationDegrees! //longitud
    var longitude:CLLocationDegrees! //latitud
    var latDelta: CLLocationDegrees! //zoom
    var longDelta: CLLocationDegrees! //zoom
    var span: MKCoordinateSpan! // obtiene el zoom
    var location: CLLocationCoordinate2D! // obtiene la localización
    var region: MKCoordinateRegion! // obtiene la region con "location" y "span"
    var newCoordinate: CLLocationCoordinate2D! //nueva coordenada segun donde presione
    
    //locationManager
    var locationManager = CLLocationManager()
    

    
    
//***********ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //locationManager
        locationManager.delegate = self                             //se delegal al viewControllew
        locationManager.desiredAccuracy = kCLLocationAccuracyBest   // la mejor presición
        locationManager.requestWhenInUseAuthorization()             //requerir autorización al estar en uso
        locationManager.startUpdatingLocation()                     //empezar la localización
        
        
        latitude = 19.372322
        longitude = -99.1737794
        latDelta = 0.01
        longDelta = 0.01
        
        //locacion en el mapa
        location = CLLocationCoordinate2DMake(latitude, longitude)
        span = MKCoordinateSpanMake(latDelta, longDelta)
        region = MKCoordinateRegionMake(location, span)
        mapa.setRegion(region, animated: true)
        mapa.showsUserLocation = true
        
        //annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Lat: \(latitude), lon: \(longitude)"
        annotation.subtitle = "Start"
        
        mapa.addAnnotation(annotation)
        
        //reconocer gesto de presion
        let uilpgr = UILongPressGestureRecognizer(target: self, action: "action:")
        uilpgr.minimumPressDuration = 2 //tiempo de reconocimiento en segundos
        mapa.addGestureRecognizer(uilpgr)
        
        
        
    }
    
    func action(gestureRecognizer: UIGestureRecognizer){
    
        let touchPoint = gestureRecognizer.locationInView(self.mapa)//reconoce donde estamos presionando en el view del mapa
         newCoordinate = mapa.convertPoint(touchPoint, toCoordinateFromView: self.mapa)
        
        //annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinate
        annotation.title = "Lat: \(latitude), lon: \(longitude)"
        annotation.subtitle = " new Start"
        
        mapa.addAnnotation(annotation)
        
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print(locations)
        let userLocation: CLLocation = locations[0] 
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        
        
        latDelta = 0.01
        longDelta = 0.01
        
        //locacion en el mapa
        location = CLLocationCoordinate2DMake(latitude, longitude)
        span = MKCoordinateSpanMake(latDelta, longDelta)
        region = MKCoordinateRegionMake(location, span)
        mapa.setRegion(region, animated: true)
        
        /*
        //Marcando una ruta
        //let startLatitude = +37.33165083
        //let startLongitude = -122.03029752
        let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2DMake(startLatitude, startLongitude), addressDictionary: nil))
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2DMake(latitude, longitude), addressDictionary: nil))
        let directionsRequest = MKDirectionsRequest()
        directionsRequest.source = source
        directionsRequest.destination = destination
        
        let directions = MKDirections(request: directionsRequest)
        
        directions.calculateDirectionsWithCompletionHandler {(response, error) -> Void in
            print(response!.routes.first!.distance)
            
            if (error != nil) {
            
            let distance = response!.routes.first!.distance // meters
            print("\(distance) meters")
                
            }else{
            
                print("ocurrio un error")
            }
        }
        */
        
        
    }
    
 
    




}

