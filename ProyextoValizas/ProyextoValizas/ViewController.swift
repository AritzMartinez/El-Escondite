//
//  ViewController.swift
//  ProyextoValizas
//
//  Created by Carlos Hernández on 31/1/18.
//  Copyright © 2018 Carlos Hernández. All rights reserved.
//

import UIKit

import SRCountdownTimer
import CoreLocation

class ViewController: UIViewController, SRCountdownTimerDelegate , CLLocationManagerDelegate{
    
    var region: CLBeaconRegion!
    var manager: CLLocationManager?
    
    let miBaliza = Baliza(uuid: "f7826da6-4fa2-4e98-8024-bc5b71e0893e",
                          major: 58387,
                          minor: 33802,
                          id: "com.jaureguialzo.ejemplobeacon")
    
   
    
    @IBOutlet weak var contadorSOS: SRCountdownTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contadorSOS.delegate = self

        self.manager = CLLocationManager()

        enableLocationServices()

        region = CLBeaconRegion(proximityUUID: UUID(uuidString: miBaliza.uuid)!, identifier: miBaliza.id)
        
    }
    
       
        
    
    func enableLocationServices() {
        manager?.delegate = self

        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            manager?.requestWhenInUseAuthorization()
            break
            
        case .restricted, .denied:
            print("No tenemos acceso a la localización")
            
            break
            
        case .authorizedWhenInUse:
            print("Localización sólo al usar la aplicación")
            
            break
            
        case .authorizedAlways:
           print("Localización permanente")
            
            break
        }
    
    }

   
    
    
    @IBAction func test(_ sender: Any) {
        
        self.manager?.startMonitoring(for: self.region!)

        let alertController = UIAlertController(title: "iOScreator", message:
            "Aqui va la baliza mas cercana", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func cancelar(_ sender: UIButton) {
        //este es el que cancela la accion
        contadorSOS.start(beginingValue: 3)
        contadorSOS.pause()
        
    }
    
    
    @IBAction func mantener(_ sender: UIButton) {
        //este boton es el que inicia
        contadorSOS.start(beginingValue: 3)
    }
    
    
    
    
    func timerDidEnd() {
        
        //envia el aviso
        print("SOS!!!!")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(_ manager: CLLocationManager,
                         didStartMonitoringFor region: CLRegion) {
        manager.startRangingBeacons(in: region as! CLBeaconRegion) // Para pruebas
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        manager.startRangingBeacons(in: region as! CLBeaconRegion)
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        manager.stopRangingBeacons(in: region as! CLBeaconRegion)
    }

    func locationManager(_ manager: CLLocationManager,
                         didRangeBeacons beacons: [CLBeacon],
                         in region: CLBeaconRegion) {
    
        
        guard let nearestBeacon = beacons.first else { return }
        
        if nearestBeacon.major == 58387 && nearestBeacon.minor == 33802{
            
        print(nearestBeacon)

        switch nearestBeacon.proximity {
        case .far:
            view.backgroundColor = .red
            print("Lejos")
            print(nearestBeacon.rssi)
            
        case .immediate:
            view.backgroundColor = .green
            print("Cerca")
            print(nearestBeacon.rssi)
        case .near:
            view.backgroundColor = .yellow
            print("Medio")
            print(nearestBeacon.rssi)
        default:
            view.backgroundColor = .blue
            print("Otro")
            print(nearestBeacon.rssi)
        }
    }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        print(error.localizedDescription)
    }

}
