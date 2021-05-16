//
//  AllListsViewControllerTableViewController.swift
//  Checklists
//
//  Created by Emil Shafigin on 12/17/17.
//  Copyright © 2017 emksh. All rights reserved.
//

import UIKit

class AllListsViewControllerTableViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {

  var dataModel: DataModel!
  let cellIdentifier = "ChecklistItem"
    
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    navigationController?.delegate = self
    
    let index = dataModel.indexOfSelectedChecklist
    if index >= 0 && index < dataModel.lists.count {
      let checklist = dataModel.lists[index]
      performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataModel.lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = cellForTableView(tableView: tableView)
      let cell: UITableViewCell!
      if let tmp = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
        cell = tmp
      } else {
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
      }
        
      let checklist = dataModel.lists[indexPath.row]
      cell.textLabel?.text = checklist.name
      cell.accessoryType = .detailDisclosureButton
      
      let count = checklist.countUncheckedItems()
      if checklist.items.count == 0 {
        cell.detailTextLabel?.text = "(No Items)"
      } else {
        cell.detailTextLabel?.text = count == 0 ? "All Done" : "\(count) Remaining"
      }
      cell.imageView?.image = UIImage(named: checklist.iconName)
      return cell
    }
    
    //MARK: - UITableViewDelegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //TODO: Store the index of the selected row into UserDefaults
      dataModel.indexOfSelectedChecklist = indexPath.row
      
      let checklist = dataModel.lists[indexPath.row]
      performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
      let controller = storyboard!.instantiateViewController(withIdentifier: "ListDetailViewController") as! ListDetailViewController
      controller.delegate = self
    
      let checklist = dataModel.lists[indexPath.row]
      controller.checklistToEdit = checklist
        
      navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: - UITableViewDataSource methods
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    //MARK: - ListDetailViewControllerDelegate
    
    func listDetailViewControllerDidCancel(controller: ListDetailViewController) {
      navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
      dataModel.lists.append(checklist)
      dataModel.sortChecklists()
      tableView.reloadData()
      navigationController?.popViewController(animated: true)
    }
    
  func listDetailViewController(controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
    dataModel.sortChecklists()
    tableView.reloadData()
    navigationController?.popViewController(animated: true)
  }
    
    //MARK: - Helper methods
    
  func cellForTableView(tableView: UITableView) -> UITableViewCell {
      let cellId = "CellId"
        
      if let cell = tableView.dequeueReusableCell(withIdentifier: cellId){
          return cell
      } else {
          return UITableViewCell(style: .default, reuseIdentifier: cellId)
      }
  }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as! ChecklistViewController
          controller.checklist = sender as? Checklist
        } else if segue.identifier == "AddChecklist" {
            let controller  = segue.destination as! ListDetailViewController
            controller.delegate = self
            //controller.checklistToEdit = nil
        }
    }
  
  //MARK: - Navigation Controller Delegates
  func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    if viewController === self {
      dataModel.indexOfSelectedChecklist = -1
    }
  }
  
}
