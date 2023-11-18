//
//  ViewController.swift
//  Project-22
//
//  Created by Phong Nguyễn Hoàng on 16/11/2023.
//
import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var distanceImage: UIImageView!
    @IBOutlet var beaconName: UILabel!
    @IBOutlet var distanceReading: UILabel!
    var beaconList = [["id": "8794EAD7-0ADB-42A6-89FD-8DE29FCE59D5", "name": "Phong 1"],
                      ["id": "E9F219E2-AE9A-4FE2-8490-8E3E96FFDDA6", "name": "Phong 2"]]
    var locationManager: CLLocationManager?
    var theLastDetectedBeacon: String = ""
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        
        distanceImage.layer.cornerRadius = 128
        doTimeOut()
//        view.backgroundColor = .gray
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(status.rawValue)
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        print("startScanning")
        beaconList.forEach { info in
            let uuid = UUID(uuidString: info["id"]!)!
            let beaconConstrain = CLBeaconIdentityConstraint(uuid: uuid)
            let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: beaconConstrain, identifier: info["name"]!)
            
            locationManager?.startMonitoring(for: beaconRegion)
            locationManager?.startRangingBeacons(satisfying: beaconConstrain)
        }
    }
    
    func update(name: String = "", distance: CLProximity) {
        beaconName.text = name
        UIView.animate(withDuration: 1) {
            switch distance {
            case .far:
                self.distanceImage.layer.backgroundColor = UIColor.blue.cgColor
                self.distanceImage.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
                self.distanceReading.text = "FAR"
            case .near:
                self.distanceImage.layer.backgroundColor = UIColor.orange.cgColor
                self.distanceImage.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self.distanceReading.text = "NEAR"
            case .immediate:
                self.distanceImage.layer.backgroundColor = UIColor.red.cgColor
                self.distanceImage.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.distanceReading.text = "RIGHT HERE"
            case .unknown:
                fallthrough
            @unknown default:
                self.distanceImage.layer.backgroundColor = UIColor.gray.cgColor
                self.distanceImage.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                self.distanceReading.text = "UNKNOWN"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
//            print("locationManager \(beacon.proximityUUID)")
            if beacon.uuid.uuidString != theLastDetectedBeacon {
                theLastDetectedBeacon = beacon.uuid.uuidString
                notifyDetected()
            }
            update(name: beaconList.filter({ info in
                info["id"]! == beacon.uuid.uuidString
            }).first!["name"]!, distance: beacon.proximity)
            doTimeOut()
        }
    }
    
    func doTimeOut() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: {[weak self] _ in
            self?.update(distance: .unknown)
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("locationManager \(region)")
    }
    
    func notifyDetected() {
        let ac = UIAlertController(title: "Detected", message: theLastDetectedBeacon, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

