//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Emil Shafigin on 12/16/17.
//  Copyright © 2017 emksh. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, NSCoding {
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(checked, forKey: "Checked")
    }
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "Text") as! String
        checked = aDecoder.decodeBool(forKey: "Checked")
        
        super.init()
    }
    
    override init() {
        super.init()
    }
    
    var text = ""
    var checked = false
    var title = ""
    
    func toggleChecked() {
        checked = !checked
    }
}
