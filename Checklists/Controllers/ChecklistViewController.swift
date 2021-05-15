//
//  ViewController.swift
//  Checklists
//
//  Created by Emil Shafigin on 12/15/17.
//  Copyright © 2017 emksh. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    var checklist: Checklist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = checklist.name
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        let item = checklist.items[indexPath.row]
        
        configureTextForCell(cell: cell, withChecklistItem: item)
        configureCheckmarkForCell(cell: cell, withChecklistItem: item)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            
          let item = checklist.items[indexPath.row]
            
          item.toggleChecked()
//          checklist.sortItems()
//          tableView.reloadData()
          
          
          if item.checked {
            checklist.items.append(item)
            checklist.items.remove(at: indexPath.row)
            
          } else {
            checklist.items.remove(at: indexPath.row)
            checklist.items.insert(item, at: 0)
          }
          tableView.reloadData()
          
          configureCheckmarkForCell(cell: cell, withChecklistItem: item)
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        checklist.items.remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    //Help functions
    func configureCheckmarkForCell(cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
        
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked {
            label.text = "✓"
        } else {
            label.text = ""
        }
    }
    
    func configureTextForCell(cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    //MARK: - ItemDetailViewControllerDelegate
    
    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {
        
//      let newRowIndex = checklist.items.count
        
//      checklist.items.append(item)
      checklist.items.insert(item, at: 0)
      tableView.reloadData()
        
//      let indexPath = IndexPath(row: newRowIndex, section: 0)
//      tableView.insertRows(at: [indexPath], with: .automatic)
        
      dismiss(animated: true, completion: nil)
    }
    
  func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem) {
    
    if let index = checklist.items.index(of: item) {
      
      let indexPath = IndexPath(row: index, section: 0)
      if let cell = tableView.cellForRow(at: indexPath) {
        configureTextForCell(cell: cell, withChecklistItem: item)
      }
    }
    dismiss(animated: true, completion: nil)
  }
    
  //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AddItem" {
            let navController = segue.destination as! UINavigationController
            let controller = navController.topViewController as! ItemDetailViewController
            
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let navController = segue.destination as! UINavigationController
            let controller = navController.topViewController as! ItemDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
    
}

