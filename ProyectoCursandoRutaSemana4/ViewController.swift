//
//  ViewController.swift
//  ProyectoCursandoRutaSemana4
//
//  Created by Josep Palau Caballero on 24/01/2018.
//  Copyright © 2018 Palau Innova. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    private let manejador = CLLocationManager()
    
    @IBOutlet weak var mapVista: MKMapView!
    
    @IBOutlet weak var mapaBtn: UIButton!
    @IBOutlet weak var híbridoBtn: UIButton!
    @IBOutlet weak var sateliteBtn: UIButton!
    
    var puntoCupertino = CLLocationCoordinate2D()
    var puntoActual = CLLocationCoordinate2D()
    var puntosRutaArray = [CLLocationCoordinate2D]()
    var pinsRutaArray = [MKAnnotation]()
    var puntoUltimoRuta: CLLocation!
    var i: Int = 0
    
    let distanciaForm = MKDistanceFormatter()
    var camara: MKMapCamera!
  
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            manejador.startUpdatingLocation()
            mapVista.showsUserLocation = true
        }
        else {
            manejador.stopUpdatingLocation()
            mapVista.showsUserLocation = false
        }
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        manejador.requestWhenInUseAuthorization()
        distanciaForm.units = .metric
       
    }
  
    var distanciaAcumulada: Double = 0
    
    var puntoActualLocation: CLLocation!
    var distancia = CLLocationDistance(exactly: 0)
    var distanciaDouble: Double = 0
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        puntoActual.latitude = manager.location!.coordinate.latitude
        puntoActual.longitude = manager.location!.coordinate.longitude
        
        camara = MKMapCamera(lookingAtCenter: puntoActual, fromEyeCoordinate: puntoActual, eyeAltitude: zoomDistance)
        mapVista.setCamera(camara, animated: true)
       
        i = puntosRutaArray.count
        
        if puntosRutaArray.count >= 1 {
       
        puntoUltimoRuta = CLLocation(latitude: puntosRutaArray[i-1].latitude, longitude: puntosRutaArray[i-1].longitude)
        puntoActualLocation = CLLocation(latitude: puntoActual.latitude, longitude: puntoActual.longitude)
        distancia = puntoActualLocation.distance(from: puntoUltimoRuta) as Double
        distanciaDouble = Double(distancia!)
        
        }
        
        if  distanciaDouble >= 50.00 {
            let pinRutaNuevo = MKPointAnnotation()
            puntosRutaArray.append(puntoActual)
            pinRutaNuevo.coordinate = puntoActual
            mapVista.addAnnotation(pinRutaNuevo)
            pinsRutaArray.append(pinRutaNuevo)
            distanciaAcumulada += 50
            pinRutaNuevo.title = "\(puntoActual.latitude.description, puntoActual.longitude.description)"
            pinRutaNuevo.subtitle = "\(distanciaAcumulada) m"
                
            }
        
        }
    
    @IBAction func rutaBtn(_ sender: Any) {
        
        let pinMapa1 = MKPointAnnotation()
        pinMapa1.coordinate = puntoActual
        pinMapa1.title = "\(pinMapa1.coordinate.latitude.description, pinMapa1.coordinate.longitude.description)"
        pinMapa1.subtitle = "0 m"
        pinsRutaArray.append(pinMapa1)
        mapVista.addAnnotation(pinMapa1)
        
        puntoUltimoRuta = CLLocation(latitude: puntoActual.latitude, longitude: puntoActual.longitude)
        puntosRutaArray.append(puntoActual)
        zoomDistance = 2000
        
    }
    
    var zoomDistance: CLLocationDistance = 7000
    
    @IBAction func zoonIn(_ sender: Any) {
        
        if camara.altitude > 1000 && camara.altitude <= 7000 {
            zoomDistance -= 1000.0
        }
        
    }
    
    @IBAction func zoomOut(_ sender: Any) {
        
        if camara.altitude < 7000 && camara.altitude >= 1000  {
            zoomDistance += 1000.0
        }
        
    }
    
    @IBAction func vistaStandard(_ sender: Any) {
    mapVista.mapType = .standard
    }
    
    @IBAction func vistaSatelite(_ sender: Any) {
        mapVista.mapType = .satellite
    }
    
    @IBAction func vistaHibrido(_ sender: Any) {
        mapVista.mapType = .hybrid
    }

    
}

