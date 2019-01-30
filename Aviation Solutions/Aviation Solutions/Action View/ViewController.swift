//
//  ViewController.swift
//  Aviation Solutions
//
//  Created by Kim Do on 11/21/18.
//  Copyright © 2018 Kim Do. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import CoreLocation
import MapKit

class ViewController: UIViewController, ARSCNViewDelegate {

   @IBOutlet weak var backBtn          : UIButton!
   @IBOutlet weak var zuluTimeLabel    : UILabel!
   @IBOutlet var      sceneView        : ARSCNView!
   @IBOutlet weak var compass          : UILabel!
   @IBOutlet weak var menuTableView    : UITableView!
   @IBOutlet weak var rightView        : UIView!
   @IBOutlet weak var rightTableView   : UITableView!
   @IBOutlet weak var enterBtn         : UIButton!
   @IBOutlet var      popUpView        : UIView!
   @IBOutlet weak var mapView          : MKMapView!
   @IBOutlet weak var popUpViewNavBar  : UINavigationBar!
   @IBOutlet weak var popUpViewLocationInput: UITextField!
   @IBOutlet weak var targetLocationLabel: UITextField!
   @IBOutlet var popUpTimerView: UIView!
   @IBOutlet weak var popUpTimerLabel: UILabel!
   @IBOutlet weak var popUpTimerNavBar: UINavigationBar!
   
   var  annotation : Annotation!
   
   var isDirection = false
   var isDistance  = false
   var timer = Timer()
   var locationManager : CLLocationManager!
   
   var MENU = [("Enter Target", false), ("Select Weapon", false), ("Set Target Time", false)]
   var TARGETS = [("All Format use WGS-84 Datum",""                    , false),
                  ("Direction / Distance", "" , false),
                  ("MGRS"                , "" ,false),
                  ("Lat/Lon"             , "" , false),
                  ("Elevation"            , "", false)
                  ]
   var WEAPONS = [("Strafe (20mm)"                 ,10,false),
                  ("Strafe (30mm)"                 ,0,false),
                  ("Unguied Bomb (MK-82)"          ,10,false),
                  ("Laser Guided Bomb (GBU-12)"    ,0,false),
                  ("Inertially Aided Bomb (GBU-38)",0,false)]
   var TARGET_TIME = [("Time On Target"      ,"",false),
                      ("Time To Target"      ,"",false),
                      ("10 Seconds from Now" ,"",false),
                      ("30 Seconds from Now" ,"", false)]
   
   
   var nextChoice = 0
   var currentLocation : CLLocationCoordinate2D!
   var stage  = HOME
   var targetLocation : CLLocationCoordinate2D!
   
   override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
      
        setUpFrontPage()
//         self.popUpViewLocationInput.keyboardDismissMode = .onDrag // .interactive
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        // Create a session configuration
      let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
      
        // Pause the view's session
        sceneView.session.pause()
    }
   
   
   
   @IBAction func menuBtnClicked(_ sender: UIButton) {
      if sender.titleLabel?.text == "Menu"{
         
         
         UIView.animate(withDuration: 0.5) {
            sender.setTitle("Back", for: .normal)
            self.menuTableView.alpha = 1
         }
      }else{
         UIView.animate(withDuration: 0.5, animations: {
            sender.setTitle("Menu", for: .normal)
            self.menuTableView.alpha = 0
            self.rightView.alpha     = 0
         }) { (done) in
            self.reset()
            self.menuTableView.reloadData()
         }
      }
   }
   
   
   @IBAction func locationInputing(_ sender: UITextField) {
      if popUpViewNavBar.topItem?.title == "Enter Direction / Distance"{
         
         if let input = sender.text{
            sender.text = filterEnterDirection_Distance(str: input)
         }
      }
   }
  
   
   @IBAction func lockLocationBtnClicked(_ sender: Any) {
      let location = targetLocationLabel.text!
      if let targetLocation = targetLocation{
         TARGETS[1].1 = location
         TARGETS[1].2 = true
         TARGETS[3].1 = targetLocation.dms.latitude + " " + targetLocation.dms.longitude
      }
      
      rightTableView.reloadData()
      animateOut()
      
   }
   @IBAction func cancleLocationBtnClicked(_ sender: Any) {
      animateOut()
   }
  
   var popUpTimerCount : Double = 3
   var popUpTimer : Timer?
   @IBAction func popUpTimerAddTouchDown(_ sender: UIButton) {
      
      popUpTimerCount = 2
      
      popUpTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (popUpTimer) in
         self.popUpTimerCount -= 0.5
      
         if self.popUpTimerCount == 0{
            let items = self.popUpTimerLabel.text!.split(separator: ":")
            var hours : Int   = Int(String((items.first!)))!
            var minutes : Int = Int(String((items[1])))!
            var seconds : Int = Int(String((items.last!)))!
            
            
            self.popUpTimerCount = 0.5
            
            if sender.titleLabel?.text == "+"{
               if sender.tag == 0{
                  let extra = 5 - seconds % 5
                  seconds = seconds+extra
                  if seconds == 60{
                     seconds = 0
                     minutes += 1
                  }
                  
               }else{
                  let extra = 5 - minutes % 5
                  minutes = minutes+extra
                  if minutes == 60{
                     minutes = 0
                     hours += 1
                  }
               }
            }else{
               if sender.tag == 0{
                  var extra = seconds % 5
                  if extra == 0{
                     extra = 5
                  }
                  seconds =  seconds-extra
                  
                  if seconds == -1{
                     minutes -= 1
                     seconds = 59
                  }
               }else{
                  let extra = minutes % 5
                  minutes =  minutes-extra
                  if minutes == -1{
                     hours -= 1
                     minutes = 59
                  }
               }
            }
            self.popUpTimerLabel.text =  String(format: "%02d:%02d:%02d", hours, minutes, seconds)
         }//         Display
         
      }
   }
   
   @objc func firePopUpTimer() {
      print("Timer fired!")
   }
   
  
   @IBAction func popUpTimerAddPressed(_ sender: UIButton) {
      let items = self.popUpTimerLabel.text!.split(separator: ":")
      var hours : Int   = Int(String((items.first!)))!
      var minutes : Int = Int(String((items[1])))!
      var seconds : Int = Int(String((items.last!)))!
      
      
      popUpTimer?.invalidate()
      if sender.titleLabel?.text == "+"{
         if sender.tag == 0{
            seconds += 1
            
            if seconds == 60{
               seconds = 0
               minutes += 1
            }
         }else{
            minutes += 1
            if minutes == 60{
               minutes = 0
               hours += 1
            }
         }
      }else{
         if sender.tag == 0{
            seconds -= 1
            if seconds == -1{
               minutes -= 1
               seconds = 59
               
            }
         }else{
            minutes -= 1
            if minutes == -1{
               minutes = 59
               hours  -= 1
            }
            
         }
      }
      
      self.popUpTimerLabel.text =  String(format: "%02d:%02d:%02d", hours, minutes, seconds)
   }
   
   @IBAction func cancelPopUpTimerView(_ sender: Any) {
      setTimerAnimateOut()
   }
   
   @IBAction func setTimerBtnClicked(_ sender: Any) {
      if let title = self.popUpTimerNavBar.topItem?.title{
         for i in 0..<TARGET_TIME.count{
            TARGET_TIME[i].2 = false
         }
         
         if title.contains("On"){
            if let timeOnTarget = self.popUpTimerLabel.text{
               self.TARGET_TIME[0].1 = timeOnTarget
               self.TARGET_TIME[0].2 = true
               self.TARGET_TIME[1].1 = differenceTime(timeOnTarget: timeOnTarget)
            }
         }else if title.contains("To"){
            if let timeOnTarget = self.popUpTimerLabel.text{
               self.TARGET_TIME[1].2 = true
               self.TARGET_TIME[1].1 = TimeToTargetFormat(timeOnTarget: timeOnTarget)
               self.TARGET_TIME[0].1 = getTimeOnTarget(timeOnTarget: timeOnTarget)
            }
         }
         
         enterBtn.alpha = 1
         setTimerAnimateOut()
         
      }
      
   }
   
   func TimeToTargetFormat(timeOnTarget: String) -> String{
      let items    = timeOnTarget.split(separator: ":")
      let target_hours    : Int   = Int(String((items.first!)))!
      let target_minutes  : Int = Int(String((items[1])))!
      let target_seconds  : Int = Int(String((items.last!)))!
      
      if target_hours > 0{
         return String(format: "%02d+%02d\"%02d'", target_hours, target_minutes, target_seconds)
      }
      
      return  String(format: "%02d+%02d'", target_minutes, target_seconds)
   }
   
   func getTimeOnTarget(timeOnTarget: String) -> String{
      let items    = timeOnTarget.split(separator: ":")
      let currents = self.zuluTimeLabel.text?.split(separator: ".").first!.split(separator: ":")
      let target_hours    : Int   = Int(String((items.first!)))!
      let target_minutes  : Int = Int(String((items[1])))!
      let target_seconds  : Int = Int(String((items.last!)))!
      let current_hours   : Int   = Int(String((currents!.first!)))!
      let current_minutes : Int = Int(String((currents![1])))!
      let current_seconds : Int = Int(String((currents!.last!)))!
      
      var differentHours    : Int = target_hours   + current_hours
      var differentMinutes  : Int = target_minutes + current_minutes
      var differentSeconds  : Int = target_seconds + current_seconds
      
      if differentSeconds >= 60{
         differentSeconds -= 60
         differentMinutes += 1
      }else if differentSeconds < 0{
         differentSeconds += 60
         differentMinutes -= 1
      }
      
      if differentMinutes >= 60{
         differentMinutes -= 60
         differentHours += 1
      }else if differentMinutes < 0{
         differentMinutes += 60
         differentHours    -= 1
      }
      return String(format: "%02d:%02d:%02d", differentHours, differentMinutes, differentSeconds)
      
   }
   
   func differenceTime(timeOnTarget: String) -> String{
      let items    = timeOnTarget.split(separator: ":")
      let currents = self.zuluTimeLabel.text?.split(separator: ".").first!.split(separator: ":")
      let target_hours    : Int   = Int(String((items.first!)))!
      let target_minutes  : Int = Int(String((items[1])))!
      let target_seconds  : Int = Int(String((items.last!)))!
      let current_hours   : Int   = Int(String((currents!.first!)))!
      let current_minutes : Int = Int(String((currents![1])))!
      let current_seconds : Int = Int(String((currents!.last!)))!
      
      var differentHours    : Int = target_hours   - current_hours
      var differentMinutes  : Int = target_minutes - current_minutes
      var differentSeconds  : Int = target_seconds - current_seconds
      
      if differentSeconds >= 60{
         differentSeconds -= 60
         differentMinutes += 1
      }else if differentSeconds < 0{
         differentSeconds += 60
         differentMinutes -= 1
      }
      
      if differentMinutes >= 60{
         differentMinutes -= 60
         differentHours += 1
      }else if differentMinutes < 0{
         differentMinutes += 60
         differentHours    -= 1
      }
      
      if differentHours > 0{
        return String(format: "%02d+%02d\"%02d'", differentHours, differentMinutes, differentSeconds)
      }
      
      return  String(format: "%02d+%02d'", differentMinutes, differentSeconds)
      
   }
}


