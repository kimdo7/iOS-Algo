//
//  ViewControllerExt.swift
//  Aviation Solutions
//
//  Created by Kim Do on 11/22/18.
//  Copyright © 2018 Kim Do. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

extension ViewController{
   func setUpFrontPage(){
      backBtn.layer.cornerRadius = 10
      backBtn.layer.borderWidth  = 1
      backBtn.layer.borderColor  = UIColor.black.cgColor
      
      enterBtn.layer.cornerRadius = 10
      enterBtn.layer.borderWidth  = 1
      enterBtn.layer.borderColor  = UIColor.black.cgColor
      enterBtn.alpha              = 0
      
      timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector:#selector(self.tick) , userInfo: nil, repeats: true)
      
      mapView.showsUserLocation = true
      mapView.mapType           = .satelliteFlyover
      
      locationManager                    = CLLocationManager()
      locationManager.delegate           = self
      locationManager.headingOrientation = CLDeviceOrientation.landscapeLeft
      locationManager.desiredAccuracy    = kCLLocationAccuracyNearestTenMeters
      locationManager.startUpdatingHeading()
      locationManager.startUpdatingLocation()
      locationManager.requestWhenInUseAuthorization()
      
      menuTableView.dataSource           = self
      menuTableView.delegate             = self
      menuTableView.backgroundColor      = UIColor.clear
      menuTableView.isScrollEnabled      = false
      menuTableView.alwaysBounceVertical = false
      menuTableView.alpha                = 0
      
      rightView.backgroundColor  = UIColor.clear
      rightView.alpha            = 0
      
      rightTableView.backgroundColor      = UIColor.clear
      rightTableView.dataSource           = self
      rightTableView.delegate             = self
      rightTableView.isScrollEnabled      = false
      rightTableView.alwaysBounceVertical = false
      
   }
   
   func reset(){
      self.stage               = HOME
      self.nextChoice          = ENTER_TARGET
      self.MENU                = [("Enter Target", false), ("Select Weapon", false), ("Set Target Time", false)]
   }
   
   func animateIn( ){
      
      self.popUpView.layer.cornerRadius = 10
      self.view.addSubview(popUpView)
      let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
      
      mapView.addGestureRecognizer(tap)
      
      popUpView.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
      
      popUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
      popUpView.alpha = 0
      
      
      self.popUpViewNavBar.topItem?.title = "Enter Direction / Distance"
      self.popUpViewLocationInput.keyboardType = .numbersAndPunctuation
      
      UIView.animate(withDuration: 0.4){
         self.popUpView.alpha = 1
         self.popUpView.transform = CGAffineTransform.identity
      }
   }
   
   func setTimerAnimateIn(){
      self.popUpTimerView.layer.cornerRadius = 10
      self.view.addSubview(popUpTimerView)
      popUpTimerView.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
      
      popUpTimerView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
      popUpTimerView.alpha = 0
      
      UIView.animate(withDuration: 0.4){
         self.popUpTimerView.alpha = 1
         self.popUpTimerView.transform = CGAffineTransform.identity
      }
   }
   
   func animateOut()  {
      UIView.animate(withDuration: 0.3, animations: {
         self.popUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
         self.popUpView.alpha = 0
         
      }){(success :Bool) in
         self.popUpView.removeFromSuperview()
      }
   }
   
   func setTimerAnimateOut()  {
      UIView.animate(withDuration: 0.3, animations: {
         self.popUpTimerView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
         self.popUpTimerView.alpha = 0
         
      }){(success :Bool) in
         self.popUpTimerView.removeFromSuperview()
         self.rightTableView.reloadData()
      }
   }
   
   func filterEnterDirection_Distance(str: String) -> String {
      var input = str
      if !input.contains(" "){
         if isDirection == false || input.contains("°"){
            isDirection = true
            input = input.digits
            if input.count == 4{
               input.removeLast()
            }else if input.count == 3{
               if Int(input)! > 360{
                  input = String(Int(input)! % 360)
               }
            }
            
            input += "°"
         }else{
            if !input.isEmpty{ input.removeLast() }
            
            if !input.isEmpty{
               input += "°"
            }else{
               isDirection = false
            }
         }
         
      }
      else if input.split(separator: " ").count == 2{
         let degree   = String(input.split(separator: " ")[0])
         var distance = String(input.split(separator: " ")[1])
         
         if isDistance == false || distance.contains("m"){
            isDistance = true
            distance = distance.digits + "m"
            
            targetLocation = getTargetLocation(targetDegree: Int(degree.digits)!, distance: Int(distance.digits)!)
            
            if annotation == nil{
               annotation =  Annotation(title: "King David Kalakaua",
                                        locationName: "Waikiki Gateway Park",
                                        discipline: "Sculpture",
                                        coordinate: targetLocation)
            }else{
               mapView.removeAnnotation(annotation)
               annotation =  Annotation(title: "King David Kalakaua",
                                        locationName: "Waikiki Gateway Park",
                                        discipline: "Sculpture",
                                        coordinate: targetLocation)
               
            }
            mapView.addAnnotation(annotation)


            
         }else{
            if !distance.isEmpty{ distance.removeLast() }
            
            if !distance.isEmpty{
               targetLocation = getTargetLocation(targetDegree: Int(degree.digits)!, distance: Int(distance.digits)!)
               
               if annotation == nil{
                  annotation =  Annotation(title: "King David Kalakaua",
                                           locationName: "Waikiki Gateway Park",
                                           discipline: "Sculpture",
                                           coordinate: targetLocation)
               }else{
                  mapView.removeAnnotation(annotation)
                  annotation =  Annotation(title: "King David Kalakaua",
                                           locationName: "Waikiki Gateway Park",
                                           discipline: "Sculpture",
                                           coordinate: targetLocation)
                  
               }
               mapView.addAnnotation(annotation)
               
               distance += "m"
            }else{
               isDistance = false
            }
         }
         
         input = degree + " " + distance
      }
      
      return input
   }
   
   func getTargetLocation(targetDegree: Int, distance: Int) -> CLLocationCoordinate2D{
      let brng : Double = Double(targetDegree) * Double.pi / 180   //#Bearing is 90 degrees converted to radians.
      let d    : Double  = Double(distance )    //#Distance in KM
      let lat1 : Double = currentLocation.latitude  * Double.pi / 180
      let lon1 : Double = currentLocation.longitude * Double.pi / 180
      
      let lat2 :Double = asin( sin(lat1) * cos(d / R / 1000) + cos(lat1) * sin(d/R / 1000) * cos(brng))
      let lon2 :Double = lon1 + atan2(sin(brng) * sin(d/R / 1000) * cos(lat1),  cos(d/R / 1000) - sin(lat1) * sin(lat2))
      
      let lat2_degree : Double = lat2 * 180 / Double.pi
      let lon2_degree : Double = lon2 * 180 / Double.pi
      
      
      return CLLocationCoordinate2D(latitude: lat2_degree, longitude: lon2_degree)
   }
   
   @objc func tick() {
      zuluTimeLabel.text = Date().preciseGMTTime
      
   }
   
   func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
      compass.text = String(Int(newHeading.magneticHeading) ) + "°"
   }
   
   @objc func handleTap(_ sender: UITapGestureRecognizer) {
      view.endEditing(true)
   }
}
