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
    
    func documentsDirectory() -> URL {
      let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
      return path[0]
    }
    
    func dataFilePath() -> URL {
      return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    func saveChecklists() {
      let encoder = PropertyListEncoder()
      do {
        let data = try encoder.encode(lists)
        try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
      } catch {
        print("Error encoding: \(error.localizedDescription)")
      }
    }
    
  func loadChecklists() {
    let path = dataFilePath()
    if let data = try? Data(contentsOf: path) {
      let decoder = PropertyListDecoder()
      do {
        lists = try decoder.decode([Checklist].self, from: data)
      } catch {
        print("Error decoding lists array: \(error.localizedDescription)")
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
  
  func sortChecklists() {
    lists.sort { list1, list2 in
      return list1.name.localizedStandardCompare(list2.name) == .orderedAscending
    }
  }
  
  class func nextChecklistItemID() -> Int {
    let userDefaults = UserDefaults.standard
    let itemID = userDefaults.integer(forKey: "ChecklistItemID")
    userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
    return itemID
  }
}
