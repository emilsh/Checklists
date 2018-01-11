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
    
    init() {
        loadChecklists()
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
}
