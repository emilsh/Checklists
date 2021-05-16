//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by Emil Shafigin on 12/18/17.
//  Copyright © 2017 emksh. All rights reserved.
//

import UIKit

protocol ListDetailViewControllerDelegate: AnyObject {
    func listDetailViewControllerDidCancel(controller: ListDetailViewController)
    func listDetailViewController(controller: ListDetailViewController, didFinishAdding checklist: Checklist)
    func listDetailViewController(controller: ListDetailViewController, didFinishEditing checklist: Checklist)
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {
    
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  @IBOutlet weak var iconImage: UIImageView!
  
    
  weak var delegate: ListDetailViewControllerDelegate?
  
  var checklistToEdit: Checklist?
  var iconName = "Folder"
    
  override func viewDidLoad() {
    super.viewDidLoad()
      
    if let checklist = checklistToEdit {
      title = "Edit checklist"
      textField.text = checklist.name
      doneBarButton.isEnabled = true
      iconName = checklist.iconName
    }
    iconImage.image = UIImage(named: iconName)
  }
    
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    textField.becomeFirstResponder()
  }
    
    //MARK: - Actions
    
    @IBAction func cancel() {
        delegate?.listDetailViewControllerDidCancel(controller: self)
    }
    
    @IBAction func done() {
        if let checklist = checklistToEdit {
          checklist.name = textField.text!
          checklist.iconName = iconName
          delegate?.listDetailViewController(controller: self, didFinishEditing: checklist)
        } else {
          let checklist = Checklist(name: textField.text!, iconName: iconName)
          delegate?.listDetailViewController(controller: self, didFinishAdding: checklist)
        }
    }
    
    //MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
      return indexPath.section == 1 ? indexPath : nil
    }
    
  //MARK: - UITextFieldDelegate
  
func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let oldText: NSString = textField.text! as NSString
    let newText: NSString = oldText.replacingCharacters(in: range, with: string) as NSString
    doneBarButton.isEnabled = (newText.length > 0)
    return true
  }
  
  //MARK: - IconPickerViewControllerDelegate
  func iconPicker(_ picker: IconPickerViewController, didPick iconName: String) {
    self.iconName = iconName
    iconImage.image = UIImage(named: iconName)
    navigationController?.popViewController(animated: true)
  }
  
  //MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "PickIcon" {
      let controller = segue.destination as! IconPickerViewController
      controller.delegate = self
    }
  }
}
