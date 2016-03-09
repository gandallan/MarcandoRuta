//
//  ViewController.swift
//  MarcandoRuta
//
//  Created by Gandhi Mena Salas on 24/02/16.
//  Copyright © 2016 Trenx. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class ViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
//*************Outlets
    @IBOutlet weak var mapa: MKMapView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    
//*************Variables
    var originExist = false
    var origin:CLLocation?
    
    let manager = CLLocationManager()

    
//***********ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //inicializamos el manejador
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 50
        manager.requestWhenInUseAuthorization()
        
        
        
        if let latitude = manager.location?.coordinate.latitude, let longitude = manager.location?.coordinate.longitude{
            
            //locacion en el mapa
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapa.setRegion(region, animated: true)
            
            
            //añadimos pin de Inicio
            let pinLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            let InicioPin:MKPointAnnotation = MKPointAnnotation()
            InicioPin.title = "Inicio"
            InicioPin.coordinate = pinLocation
            mapa.addAnnotation(InicioPin)
            
        }else{
        
            Alerta(title: "error", message: "No podemos localizar tu ubicación")
            
        }
        

}

//**********autorizarLocalización
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            manager.startUpdatingLocation()
            mapa.showsUserLocation = true
        } else {
            manager.stopUpdatingLocation()
            mapa.showsUserLocation = false
        }
    }
    


    
    
//*********DidUpdateLocations
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let latitude = manager.location?.coordinate.latitude, let longitude = manager.location?.coordinate.longitude{
            
            //si no existe un origen le indicamos el origen
            if !originExist{
                origin = CLLocation(latitude: latitude, longitude: longitude)
                originExist = true
            }
            
            //monitoreamos las nuevas coordenadas
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapa.setRegion(region, animated: true)
            
            
            
            //Creamos el Pin
            let pin = MKPointAnnotation()
            pin.coordinate = location
            pin.title = "Latitud: \(Double(round(latitude * 100/100))), Longitud: \(Double(round(longitude * 100/100)))"
            
            if let punto = origin {
            
                pin.subtitle = "Distancia Recorrida: \(Double(round(manager.location!.distanceFromLocation(punto) * 100)/100))"
            
            }else{
                
                print("No hay punto de partida.")
                
            }
            
            self.mapa.addAnnotation(pin)
            
        }else{
            
            Alerta(title: "Error", message: "No se puede localizar tu ubicación")
            
        }
    
    }


//*********DidFailWithError
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print("\(error)")
    
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

    
//*********Alerta
    func Alerta(title title: String, message: String){
        let alerta = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let OK = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alerta.addAction(OK)
        self.presentViewController(alerta, animated: true, completion: nil)
        
    
    }
    

}

