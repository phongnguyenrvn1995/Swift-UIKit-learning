//
//  ViewController.swift
//  LearnMoreLocation
//
//  Created by Phong Nguyễn Hoàng on 30/11/2023.
//
import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationMng = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationMng.delegate = self
        locationMng.requestAlwaysAuthorization()
        print(Date.distantFuture)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            print("OK")
            locationMng.startMonitoringVisits()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        if visit.departureDate == Date.distantFuture {
            print("User arrived at location \(visit.coordinate) at time \(visit.arrivalDate)")
        } else {
            print("User departed location \(visit.coordinate) at time \(visit.departureDate)")
        }
    }
}

