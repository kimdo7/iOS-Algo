//
//  TableView.swift
//  Aviation Solutions
//
//  Created by Kim Do on 11/22/18.
//  Copyright © 2018 Kim Do. All rights reserved.
//

import Foundation
import UIKit

extension ViewController : UITableViewDataSource , UITableViewDelegate{
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      if tableView == menuTableView{
         return 1
      }
      
      if stage == ENTER_TARGET{
         if section == 0{
            return TARGETS.count - 2
         }
         return 1
      }else if stage == SELECT_WEAPON{
         return WEAPONS.count
      }else if stage == SELECT_TARGET_TIME{
         return TARGET_TIME.count
      }
      
      return 1
      
   }
   
   func numberOfSections(in tableView: UITableView) -> Int {
      if tableView == menuTableView{
         return MENU.count
      }
      
      if stage == ENTER_TARGET{
         return 2
      }else if stage == SELECT_WEAPON{
         return 1
      }else if stage == SELECT_TARGET_TIME{
         return 1
      }
      return 2
   }
   
   func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      if tableView == rightView{
         return TARGETS[0].0
      }
      return ""
   }
   
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      if tableView == menuTableView{
         let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
         cell.textLabel?.text = MENU[indexPath.section].0
         
         cell.backgroundColor       = UIColor.white
         cell.layer.borderWidth     = 1
         cell.layer.cornerRadius    = 8
         cell.textLabel?.textColor  = UIColor.black
         
         if MENU[indexPath.section].1{
            cell.layer.borderColor = UIColor.green.cgColor
         }else{
            cell.layer.borderColor = UIColor.red.cgColor
         }
         
         if stage != HOME{
            if stage != indexPath.section{
               cell.textLabel?.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
               cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            }else{
               cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            }
         }
         return cell
      }else{
         
         let cell = tableView.dequeueReusableCell(withIdentifier: "rightCell", for: indexPath)
         cell.backgroundColor       = UIColor.white
         cell.layer.borderWidth     = 1
         cell.layer.cornerRadius    = 8
         cell.clipsToBounds         = true
         
         
         if stage == ENTER_TARGET{
            if indexPath.section == 0{
               cell.textLabel?.text       = TARGETS[indexPath.row+1].0 + ": "
               cell.detailTextLabel?.text = TARGETS[indexPath.row+1].1
               cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
               
               if TARGETS[indexPath.row+1].2{
                  cell.layer.borderWidth = 3
                  cell.layer.borderColor = UIColor.black.cgColor
               }
            }else{
               cell.textLabel?.text       = TARGETS[4].0 + ": "
               cell.detailTextLabel?.text = TARGETS[4].1
            }
         }else if stage == SELECT_WEAPON{
            cell.textLabel?.text       = WEAPONS[indexPath.row].0
            cell.detailTextLabel?.text = ""
            
            if WEAPONS[indexPath.row].1 == 0{
               cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .ultraLight)
               cell.textLabel?.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            }else if WEAPONS[indexPath.row].2 == false{
               cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            }else{
               cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
               cell.layer.borderWidth  = 3
               cell.layer.borderColor  = UIColor.black.cgColor
               cell.textLabel?.font       = UIFont.systemFont(ofSize: 16, weight: .regular)
            }
         }else if stage == SELECT_TARGET_TIME{
            cell.textLabel?.text       = TARGET_TIME[indexPath.row].0
            cell.detailTextLabel?.text = TARGET_TIME[indexPath.row].1
            cell.textLabel?.textColor  = UIColor.black
            
            if TARGET_TIME[indexPath.row].2{
               cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
               cell.layer.borderWidth     = 3
               cell.layer.borderColor     = UIColor.black.cgColor
               cell.textLabel?.font       = UIFont.systemFont(ofSize: 16, weight: .regular)
            }else{
               cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            }
         }
         
         return cell
      }
   }
   
   func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      return 1
   }
   
   // Make the background color show through
   func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      let headerView = UIView()
      headerView.backgroundColor = UIColor.clear
      return headerView
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if tableView == menuTableView{
         if indexPath.section == nextChoice{ //Check for the right choice
            if nextChoice <  MENU.count{
               MENU[nextChoice].1 = true
               if nextChoice == ENTER_TARGET{
                  
                  stage = ENTER_TARGET
                  
                  UIView.animate(withDuration: 0.5) {
                     self.rightView.alpha = 1
                  }
               }else if nextChoice == SELECT_WEAPON{
                  var flag = false
                  for target in TARGETS{
                     if target.2 {
                        flag = true
                     }
                  }
                  
                  if flag == false{
                     return
                  }
                  
                  stage = SELECT_WEAPON
               }else{
                  var flag = false
                  for weapon in WEAPONS{
                     if weapon.2 {
                        flag = true
                     }
                  }
                  
                  if flag == false{
                     return
                  }
                  
                  stage = SELECT_TARGET_TIME
               }
               nextChoice += 1
            }
            
            rightTableView.reloadData()
            menuTableView.reloadData()
         }
      }
      else{
         if stage == ENTER_TARGET{
            animateIn()
         }else if stage == SELECT_WEAPON{
            if WEAPONS[indexPath.row].1 == 0{
               return
            }
            for i in 0 ..< WEAPONS.count{
               WEAPONS[i].2 = false
            }
            
            WEAPONS[indexPath.row].2 = true
            rightTableView.reloadData()
         }else{
            if indexPath.row == 0{
               self.popUpTimerNavBar.topItem?.title = "Enter " + TARGET_TIME[ indexPath[indexPath.row]].0
               self.popUpTimerLabel.text           = String((self.zuluTimeLabel.text?.split(separator: ".").first)!)
               setTimerAnimateIn()
            }else if indexPath.row == 1{
               self.popUpTimerNavBar.topItem?.title = "Enter " + TARGET_TIME[ indexPath[indexPath.row]].0
               self.popUpTimerLabel.text            = "00:00:00"
               setTimerAnimateIn()
            }
         }
      }
   }
   
   
}
