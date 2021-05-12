//
//  DataModel.swift
//  Checklists
//
//  Created by Emil Shafigin on 12/19/17.
//  Copyright © 2017 emksh. All rights reserved.
//

import Foundation

class DataModel {
  var lists = [Checklist]()
  
  var indexOfSelectedChecklist: Int {
    get {
      return UserDefaults.standard.integer(forKey: "ChecklistIndex")
    }
    set {
      UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
    }
  }
    
    init() {
      loadChecklists()
      registerDefaults()
      handleFirstTime()
    }
    
    func documentsDirectory() -> String {
      let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
      return path[0]
    }
    
    func dataFilePath() -> String? {
      let filePath = (documentsDirectory() as NSString).strings(byAppendingPaths: ["Checklists.plist"]).first
      if let dataFilePath = filePath {
        return dataFilePath as String
      } else {
        return nil
      }
    }
    
    func saveChecklists() {
      let data = NSMutableData()
      let archiver = NSKeyedArchiver(forWritingWith: data)
      archiver.encode(lists, forKey: "Checklists")
      archiver.finishEncoding()
      if let filePath = dataFilePath() {
          data.write(toFile: filePath, atomically: true)
      }
    }
    
    func loadChecklists() {
      if let path = dataFilePath() {
        if FileManager.default.fileExists(atPath: path) {
          if let data = NSData(contentsOfFile: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data as Data)
            lists = unarchiver.decodeObject(forKey: "Checklists") as! [Checklist]
            unarchiver.finishDecoding()
        }
      }
    }
  }
  
  func registerDefaults() {
    let dictionary = ["ChecklistIndex": -1, "FirstTime": true] as [String: Any]
    UserDefaults.standard.register(defaults: dictionary)
  }
  
  func handleFirstTime() {
    let userDefaults = UserDefaults.standard
    let firstTime = userDefaults.bool(forKey: "FirstTime")
    
    if firstTime {
      let checkList = Checklist(name: "List")
      lists.append(checkList)
      
      indexOfSelectedChecklist = 0
      userDefaults.set(false, forKey: "FirstTime")
    }
  }
}
