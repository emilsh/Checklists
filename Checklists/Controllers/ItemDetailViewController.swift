//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Emil Shafigin on 12/16/17.
//  Copyright © 2017 emksh. All rights reserved.
//

import UIKit
import UserNotifications

protocol ItemDetailViewControllerDelegate: class {
  func itemDetailViewControllerDidCancel(controller: ItemDetailViewController)
  func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem)
  func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  @IBOutlet var shouldRemindSwitch: UISwitch!
  @IBOutlet var datePicker: UIDatePicker!
    
  weak var delegate: ItemDetailViewControllerDelegate?
  
  var itemToEdit: ChecklistItem?
    
    //MARK: - Actions
    @IBAction func cancel() {
        delegate?.itemDetailViewControllerDidCancel(controller: self)
    }
    
    @IBAction func done() {
      if let item = itemToEdit {
        item.text = textField.text!
        item.shouldRemind = shouldRemindSwitch.isOn
        item.dueDate = datePicker.date
        item.scheduleNotification()
        delegate?.itemDetailViewController(controller: self, didFinishEditingItem: item)
      } else {
        let item = ChecklistItem()
        item.text = textField.text!
        item.checked = false
        item.shouldRemind = shouldRemindSwitch.isOn
        item.dueDate = datePicker.date
        item.scheduleNotification()
        delegate?.itemDetailViewController(controller: self, didFinishAddingItem: item)
      }
  }
  
  @IBAction func shouldRemindToggled(_ switchControl: UISwitch) {
    textField.resignFirstResponder()
    
    if switchControl.isOn {
      let center = UNUserNotificationCenter.current()
      center.requestAuthorization(options: [.alert, .sound]) { _, _ in
        // do nothing
      }
    }
  }
    
  //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit {
          title = "Edit item"
          textField.text = item.text
          doneBarButton.isEnabled = true
          shouldRemindSwitch.isOn = item.shouldRemind
          datePicker.date = item.dueDate
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    //MARK: - UITableViewDelegate methods
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    //MARK: - UITextFieldDelegate methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText: NSString = textField.text! as NSString
        let newText: NSString = oldText.replacingCharacters(in: range, with: string) as NSString
        doneBarButton.isEnabled = (newText.length > 0)
        return true
    }
}
