//
//  Location.swift
//  Aviation Solutions
//
//  Created by Kim Do on 11/22/18.
//  Copyright © 2018 Kim Do. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

extension ViewController: CLLocationManagerDelegate {
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      //1
      if locations.count > 0 {
         let location = locations.last!
         
         //2
         if location.horizontalAccuracy < 100 {
            self.currentLocation = location.coordinate
           
            //3
            manager.stopUpdatingLocation()
            let span = MKCoordinateSpan(latitudeDelta: 0.014, longitudeDelta: 0.014)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.region = region
            // More code later...
         }
      }
   }
}
