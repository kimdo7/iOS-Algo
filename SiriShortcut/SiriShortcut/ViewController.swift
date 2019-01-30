//
//  ViewController.swift
//  SiriShortcut
//
//  Created by Kim Do on 11/14/18.
//  Copyright © 2018 Kim Do. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

   @IBOutlet weak var label: UILabel!
   override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view, typically from a nib.
   }

   @IBAction func orderPizzaBtn(_ sender: Any) {
      print("order pizza")
      let activity = NSUserActivity(activityType: "Kim-Do.SiriShortcut.orderPizza")
      activity.title = "Order Pizza"
      activity.isEligibleForSearch = true
      activity.isEligibleForPrediction = true
      self.userActivity = activity
      self.userActivity?.becomeCurrent()
      
   }
   //   func setupIntents() {
//
//      let activity = NSUserActivity(activityType: "com.AppCoda.SiriSortcuts.sayHi") // 1
//
//      activity.title = "Say Hi" // 2
//
//      activity.userInfo = ["speech" : "hi"] // 3
//
//      activity.isEligibleForSearch = true // 4
//
//      activity.isEligibleForPrediction = true // 5
//
//      activity.persistentIdentifier = NSUserActivityPersistentIdentifier(rawValue: "Kim-Do.SiriShortcut.sayHi") // 6
////      activity.persistentIdentifier = NSUserActivityPersistentIdentifier(
//
//      view.userActivity = activity // 7
//
//      activity.becomeCurrent() // 8
//
//   }
}

