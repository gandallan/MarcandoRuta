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
    
    
//*************Variables
    
    //location
    var latitudeInit: CLLocationDegrees!                //longitud inicial
    var longitudeInit:CLLocationDegrees!                //latitud inicial
    var locationInit: CLLocation!                       //locación inicial
    
    //zoom
    var latUserDelta: CLLocationDegrees!                //zoom
    var longUserDelta: CLLocationDegrees!               //zoom
    var span: MKCoordinateSpan!                         // obtiene el zoom
    
    var location: CLLocationCoordinate2D!               // obtiene la localización
    var region: MKCoordinateRegion!                     // obtiene la region con "location" y "span"
    
    var newCoordinate: CLLocationCoordinate2D!          //nueva coordenada segun donde presione
    
    //User
    var userLocation: CLLocation!
    var userLatitude: CLLocationDegrees!
    var userLongitude: CLLocationDegrees!

    
    //locationManajer
    var locationManager = CLLocationManager()
    
    
    //distancia
    var distancia = 0.0
    var seconds = 0.0
    var timer = NSTimer()
    var distanciaTotal:Int =  0
    
    
//***********ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //locationManager
        locationManager.delegate = self                             //se delegal al viewControllew
        locationManager.desiredAccuracy = kCLLocationAccuracyBest   // la mejor presición
        locationManager.requestWhenInUseAuthorization()             //requerir autorización al estar en uso
        locationManager.startUpdatingLocation()                     //empezar la localización
        mapa.showsUserLocation = true                               //mostrar usuario


        
        //Timer
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "eachSecond:", userInfo: nil, repeats: true)
        eachSecond(timer)

        
        
        //reconocer gesto de presion
        let uilpgr = UILongPressGestureRecognizer(target: self, action: "action:")
        uilpgr.minimumPressDuration = 2 //tiempo de reconocimiento del gesto en segundos
        mapa.addGestureRecognizer(uilpgr)
    
        

    }
    
    
//********CadaSegundo
    
    //esta funcion será llamada cada segundo
    func eachSecond(timer:NSTimer ){
        
        seconds++
        
        //Aqui vamos sumar las distancias
        if seconds > 1 {
            
            
            distanciaTotal += Int(round(distancia))
            print(distanciaTotal)

        }else{
            
            distancia = 0.0
        
        }
        

        
        if distanciaTotal >= 50 && distanciaTotal <= 54 {
                
                //annotation
                location = CLLocationCoordinate2DMake(userLatitude, userLongitude)
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                annotation.title = "Lat: \(userLatitude), lon: \(userLatitude)"
                annotation.subtitle = "\(distanciaTotal) "
                
                mapa.addAnnotation(annotation)
            }

    }

    
    
//
    func locationManager(manager: CLLocationManager, var didUpdateLocations locations: [CLLocation]) {
        
        self.userLocation = locations[0]
        userLatitude = userLocation.coordinate.latitude             //latitud usuario
        userLongitude = userLocation.coordinate.longitude           //longitud usuario
        distancia = userLocation.speed                              //velocidad del usuario en bicicleta
        //print(locations)
        

    
        //locacion en el mapa
        latUserDelta = 0.01                                         //zoom
        longUserDelta = 0.01                                        //zoom
        
        location = CLLocationCoordinate2DMake(userLatitude, userLongitude)
        span = MKCoordinateSpanMake(latUserDelta, longUserDelta)
        region = MKCoordinateRegionMake(location, span)
        mapa.setRegion(region, animated: true)
    
        
    }
    
//**********Función de los tipos de mapas
    @IBAction func segmentedControlAction(sender: UISegmentedControl) {
        
        switch segmentControl.selectedSegmentIndex{
            
            case 0:
                mapa.mapType = MKMapType.Standard                   //mapaStandard
            case 1:
                mapa.mapType = MKMapType.Satellite                  //mapaSatelital
            default:
                mapa.mapType = MKMapType.Hybrid                     //mapaHibrido
            
        }
    }


}

