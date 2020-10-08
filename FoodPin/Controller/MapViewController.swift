//
//  MapViewController.swift
//  FoodPin
//
//  Created by 王冠之 on 2020/8/13.
//  Copyright © 2020 Wangkuanchih. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    var selectedAnnotation: MKPointAnnotation!
    
    var restaurant: RestaurantMO!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .black
        
//        mapView.showsTraffic = true
        mapView.showsCompass = true
        mapView.delegate = self

        //住址轉為座標並標記在地圖上
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(restaurant.location ?? "") { (placemarks, error) in
            if let error = error {
                print(error)
                return
            }
            
            if let placemarks = placemarks {
                //取得第一個地點標記
                let placemark = placemarks[0]
                
                //加上標記
                let annotation = MKPointAnnotation()
                annotation.title = self.restaurant.name
                annotation.subtitle = self.restaurant.type
                
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    
                    //顯示標記
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyMarker"
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        //如果可行再重複使用標記
        var annotationView: MKMarkerAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        annotationView?.glyphText = "😋"
        annotationView?.markerTintColor = UIColor.orange
        
        let button = UIButton(type: .detailDisclosure)
        button.addTarget(self, action: #selector(buttonPress(sender:)), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(buttonPress(sender:)))
        tap.numberOfTapsRequired = 1
        annotationView?.addGestureRecognizer(tap)
        
        return annotationView
    }
    
    @objc func buttonPress(sender:Any){
        print("Comes")
        negativeTo(address: restaurant.location ?? "")
    }
    
    func negativeTo(address: String) {
        let geocoder  = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            //有error就被擋
            if let error = error{
                print("geocodeArrressSting: \(error)")
                return
            }
            
            guard let placemark = placemarks?.first,
                let coordinate = placemark.location?.coordinate else{
                    assertionFailure("Invalid placemark")
                    return
            }
            print("Lat , Lon: \(coordinate.latitude), \(coordinate.longitude) ")
            //Prepare source map item
            let sourceCoordinate = CLLocationCoordinate2D(latitude: 23.686525, longitude: 121.815312)
            let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
            let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
            
            
            //Prepare targer map item
            let targetPlaceMark = MKPlacemark(placemark: placemark)
            let targetMapItem = MKMapItem(placemark: targetPlaceMark)
            let options = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
            targetMapItem.openInMaps(launchOptions: options)
            //sourceMapItem是起點, targerMapItem是終點
            MKMapItem.openMaps(with: [sourceMapItem, targetMapItem], launchOptions: options)
        }
    }
}
