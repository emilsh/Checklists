//
//  Checklist.swift
//  Checklists
//
//  Created by Emil Shafigin on 12/17/17.
//  Copyright © 2017 emksh. All rights reserved.
//

import UIKit

class Checklist: NSObject, NSCoding {
    
  var name = ""
  var items = [ChecklistItem]()
  var iconName = "No Icon"
    
  init(name: String, iconName: String = "No Icon") {
    self.name = name
    self.iconName = iconName
    super.init()
  }
    
  func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: "Name")
    aCoder.encode(items, forKey: "Items")
  }
    
  required init?(coder aDecoder: NSCoder) {
    name = aDecoder.decodeObject(forKey: "Name") as! String
    items = aDecoder.decodeObject(forKey: "Items") as! [ChecklistItem]
    super.init()
  }
  
  func countUncheckedItems() -> Int {
    return items.reduce(0) { cnt, item in
      cnt + (item.checked ? 0 : 1)
    }
  }
}
