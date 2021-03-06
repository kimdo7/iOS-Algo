//
//  Annotation.swift
//  Aviation Solutions
//
//  Created by Kim Do on 11/22/18.
//  Copyright © 2018 Kim Do. All rights reserved.
//

import Foundation
import MapKit

import MapKit

class Annotation: NSObject, MKAnnotation {
   let title: String?
   let locationName: String
   let discipline: String
   var coordinate: CLLocationCoordinate2D
   
   init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
      self.title = title
      self.locationName = locationName
      self.discipline = discipline
      self.coordinate = coordinate
      
      super.init()
   }
   
   var subtitle: String? {
      return locationName
   }
}
