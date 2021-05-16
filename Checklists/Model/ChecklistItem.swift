//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Emil Shafigin on 12/16/17.
//  Copyright © 2017 emksh. All rights reserved.
//

import Foundation
import UserNotifications

class ChecklistItem: NSObject, Codable {
    
  var text = ""
  var checked = false
  var shouldRemind = false
  var dueDate = Date()
  var itemID = -1
  
  override init() {
    super.init()
    itemID = DataModel.nextChecklistItemID()
  }
  
  required init?(coder aDecoder: NSCoder) {
      text = aDecoder.decodeObject(forKey: "Text") as! String
      checked = aDecoder.decodeBool(forKey: "Checked")
        
      super.init()
  }
  
  deinit {
    removeNotification()
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(text, forKey: "Text")
    aCoder.encode(checked, forKey: "Checked")
  }

  func toggleChecked() {
    checked = !checked
  }
  
  //MARK: - User Notifications
  func scheduleNotification() {
    removeNotification()
    
    if shouldRemind && dueDate > Date() {
      let content = UNMutableNotificationContent()
      content.title = "Reminder: "
      content.body = text
      content.sound = UNNotificationSound.default()
      
      let calendar = Calendar(identifier: .gregorian)
      let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
      
      let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
      
      let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
      
      let center = UNUserNotificationCenter.current()
      center.add(request, withCompletionHandler: nil)
    }
  }
  
  func removeNotification() {
    let center = UNUserNotificationCenter.current()
    center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
  }
}
