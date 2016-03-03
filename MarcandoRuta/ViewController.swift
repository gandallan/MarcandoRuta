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
import HealthKit

class ViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
//*************Outlets

    @IBOutlet weak var mapa: MKMapView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    
    
//*************Variables
    //location
    var latitudeInit: CLLocationDegrees! //longitud
    var longitudeInit:CLLocationDegrees! //latitud
    var latDelta: CLLocationDegrees! //zoom
    var longDelta: CLLocationDegrees! //zoom
    var span: MKCoordinateSpan! // obtiene el zoom
    var location: CLLocationCoordinate2D! // obtiene la localización
    var region: MKCoordinateRegion! // obtiene la region con "location" y "span"
    var newCoordinate: CLLocationCoordinate2D! //nueva coordenada segun donde presione
    var userLocation: CLLocation!
    var userLatitude: CLLocationDegrees!
    var userLongitude: CLLocationDegrees!
    
    //var locations = [CLLocation]()
    var locationManager = CLLocationManager()
    
    var distancia = 0.0
    var seconds = 0.0
    var timer = NSTimer()
    var distanciaTotal:Int =  0
    
    
//***********ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer.invalidate()
        
        //locationManager
        locationManager.delegate = self                             //se delegal al viewControllew
        locationManager.desiredAccuracy = kCLLocationAccuracyBest   // la mejor presición
        locationManager.requestWhenInUseAuthorization()             //requerir autorización al estar en uso
        locationManager.startUpdatingLocation()                     //empezar la localización
        
        /*
        latitudeInit = +37.33170303
        longitudeInit = -122.03024001
        latDelta = 0.01
        longDelta = 0.01
        
        
        //locacion en el mapa
        location = CLLocationCoordinate2DMake(latitudeInit, longitudeInit)
        span = MKCoordinateSpanMake(latDelta, longDelta)
        region = MKCoordinateRegionMake(location, span)
        mapa.setRegion(region, animated: true)
        
        */
        mapa.showsUserLocation = true
        
        //distancia
        //locations.removeAll(keepCapacity: false)
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "eachSecond:", userInfo: nil, repeats: true)
        eachSecond(timer)

        
        /*
        //annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Lat: \(latitudeInit), lon: \(longitudeInit)"
        annotation.subtitle = "Start"
        
        mapa.addAnnotation(annotation)
        */
        
        
        //reconocer gesto de presion
        let uilpgr = UILongPressGestureRecognizer(target: self, action: "action:")
        uilpgr.minimumPressDuration = 2 //tiempo de reconocimiento del gesto en segundos
        mapa.addGestureRecognizer(uilpgr)
        
        

    }
//*********Añadir Pin
    func action(gestureRecognizer: UIGestureRecognizer){
    
        let touchPoint = gestureRecognizer.locationInView(self.mapa)//reconoce donde estamos presionando en el view del mapa
         newCoordinate = mapa.convertPoint(touchPoint, toCoordinateFromView: self.mapa)
        
        //annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinate
        annotation.title = "Lat: \(latitudeInit), lon: \(longitudeInit)"
        annotation.subtitle = " new Start"
        
        mapa.addAnnotation(annotation)
        
    }
    
    
//********CadaSegundo
    
    //esta funcion será llamada cada segundo
    func eachSecond(timer:NSTimer ){
        
        seconds++
        
        let secondQuantity = HKQuantity(unit: HKUnit.secondUnit(), doubleValue: seconds)
        timeLabel.text = secondQuantity.description
        let distanceQuantity = HKQuantity(unit: HKUnit.meterUnit(), doubleValue: distancia)
        distanceLabel.text = distanceQuantity.description
        //print(distanceLabel.text!)
        
        
        
        
        let paceUnit = HKUnit.secondUnit().unitDividedByUnit(HKUnit.meterUnit())
        let paceQuantity  = HKQuantity(unit: paceUnit, doubleValue: seconds/distancia)
        paceLabel.text = paceQuantity.description
        
        
        //Aqui vamos sumar las distancias
        if seconds > 1 {
            
            distanciaTotal += Int(round(distancia))
            print(distanciaTotal)
        }else{
            distancia = 0.0
        }
        
        if distanciaTotal >= 50 && distanciaTotal <= 55 {
                
                //annotation
                location = CLLocationCoordinate2DMake(userLatitude, userLongitude)
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                annotation.title = "Lat: \(userLatitude), lon: \(userLatitude)"
                annotation.subtitle = "\(distanciaTotal) "
                
                mapa.addAnnotation(annotation)
            
            }
        
        
        
        
        
        
    }
    
    func locationManager(manager: CLLocationManager, var didUpdateLocations locations: [CLLocation]) {
        
        self.userLocation = locations[0]
        userLatitude = userLocation.coordinate.latitude
        userLongitude = userLocation.coordinate.longitude
        
        distancia = userLocation.speed

        latDelta = 0.01
        longDelta = 0.01
        
        //locacion en el mapa
        location = CLLocationCoordinate2DMake(userLatitude, userLongitude)
        span = MKCoordinateSpanMake(latDelta, longDelta)
        region = MKCoordinateRegionMake(location, span)
        mapa.setRegion(region, animated: true)
    
        
    }
    
//**********Función de los tipos de mapas
    @IBAction func segmentedControlAction(sender: UISegmentedControl) {
        
        switch segmentControl.selectedSegmentIndex{
            
            case 0:
                mapa.mapType = MKMapType.Standard
            case 1:
                mapa.mapType = MKMapType.Satellite
            default:
                mapa.mapType = MKMapType.Hybrid
            
        }
    }

    
 


}

