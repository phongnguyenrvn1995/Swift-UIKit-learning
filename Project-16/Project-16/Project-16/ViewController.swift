//
//  ViewController.swift
//  Project-16
//
//  Created by Phong Nguyễn Hoàng on 23/09/2023.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.mapType = .satellite
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(onChangeTypeTapped))
        navigationItem.title = String(describing: mapView.mapType)
        
        // Do any additional setup after loading the view.
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278), info: "Home to the 2012 Summer Olympics.", tintColour: UIColor.red, url: URL(string: "https://en.wikipedia.org/wiki/London"))
        let oslo  = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.9139, longitude: 10.7522), info: "Founded over a thousand years ago.", tintColour: UIColor.blue, url: URL(string: "https://en.wikipedia.org/wiki/Oslo"))
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522), info: "Often called the City of Light.", tintColour: UIColor.red, url: URL(string: "https://en.wikipedia.org/wiki/Paris"))
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9028, longitude: 12.4964), info: "Has a whole country inside it.", tintColour: UIColor.green, url: URL(string: "https://en.wikipedia.org/wiki/Rome"))
        let washington = Capital(title: "Washington D.C", coordinate: CLLocationCoordinate2D(latitude: 38.8951, longitude: -77.0369), info: "Named after George himself.", tintColour: UIColor.yellow, url: URL(string: "https://en.wikipedia.org/wiki/Washington,_D.C."))
        mapView.addAnnotations([london, oslo, paris, rome, washington])
    }
    
    @objc func onChangeTypeTapped() {
        let vc = UIAlertController(title: "Change Map Type", message: nil, preferredStyle: .actionSheet)
        let types = [MKMapType.standard, .hybrid, .hybridFlyover, .mutedStandard, .satellite, .satelliteFlyover]
        
        types.forEach { item in
            vc.addAction(UIAlertAction(title: String(describing: item), style: .default, handler: {[weak self] action in
                self?.mapView.mapType = item
                self?.navigationItem.title = action.title
            }))
        }
        
        vc.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(vc, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Capital else { return nil }
        let id = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: id)
        if(annotationView == nil) {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: id)
            annotationView?.canShowCallout = true
            annotationView?.tintColor = annotation.tintColour
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        if control != view.rightCalloutAccessoryView { return }
//        let vc = UIAlertController(title: capital.title, message: capital.info, preferredStyle: .alert)
//        vc.addAction(UIAlertAction(title: "OK", style: .default))
//        present(vc, animated: true)
        if let vc = storyboard?.instantiateViewController(identifier: "detail") as? DetailViewController {
            vc.capital = capital
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension MKMapType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .standard:
            return "Standard"
        case .hybrid:
            return "Hybrid"
        case .hybridFlyover:
            return "HybridFlyover"
        case .mutedStandard:
            return "MutedStandard"
        case .satellite:
            return "Satellite"
        case .satelliteFlyover:
            return "SatelliteFlyover"
        @unknown default:
            fatalError()
        }
    }
}
