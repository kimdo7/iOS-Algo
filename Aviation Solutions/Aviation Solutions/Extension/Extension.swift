//
//  Extension.swift
//  Aviation Solutions
//
//  Created by Kim Do on 11/21/18.
//  Copyright © 2018 Kim Do. All rights reserved.
//

import Foundation
import MapKit
extension Formatter {
   static let preciseGMTTime: DateFormatter = {
      let formatter = DateFormatter()
      formatter.locale = Locale(identifier: "en_US_POSIX")
      formatter.timeZone = TimeZone(secondsFromGMT: 0)
      formatter.dateFormat = "HH:mm:ss.SSS"
      return formatter
   }()
}

extension Date {
   // you can create a read-only computed property to return just the nanoseconds from your date time
   var nanosecond: Int { return Calendar.current.component(.nanosecond,  from: self)   }
   // the same for your local time
   
   // or GMT time
   var preciseGMTTime: String {
      return Formatter.preciseGMTTime.string(for: self) ?? ""
   }
}

extension String {
   var digits: String {
      return components(separatedBy: CharacterSet.decimalDigits.inverted)
         .joined()
   }
}
extension FloatingPoint {
   var minutes:  Self {
      return (self*3600)
         .truncatingRemainder(dividingBy: 3600)/60
   }
   var seconds:  Self {
      return (self*3600)
         .truncatingRemainder(dividingBy: 3600)
         .truncatingRemainder(dividingBy: 60)
   }
}
extension CLLocationCoordinate2D {
   var dms: (latitude: String, longitude: String) {
      return (String(format:"%@ %d° %d' %.1f\"",
                     latitude >= 0 ? "N" : "S",
                     Int(abs(latitude)),
                     Int(abs(latitude.minutes)),
                     abs(latitude.seconds)),
                     
              String(format:"%@ %d° %d' %.1     f\"",
                     longitude >= 0 ? "E" : "W",
                     Int(abs(longitude)),
                     Int(abs(longitude.minutes)),
                     abs(longitude.seconds)
                     ))
   }
}
