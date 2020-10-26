//
//  EditController.swift
//  Pomodoro
//
//  Created by 金一成 on 2020/10/6.
//

import UIKit

/*
 Protocol for back transferring to TodosTableController
 */
protocol TodoDelegate {
    func didAdd(name:String, time:Int)
    func didEdit(name:String, time:Int)
}

/*
 Edit interface
 */
class EditTableController: UITableViewController {
    
    // TodoDelegate delegate
    var delegate:TodoDelegate?
    
    // Task name
    var name:String?
    
    // Task left time
    var time:Int?

    // UI contorl for input task name text field
    @IBOutlet weak var todoInput: UITextField!
    
    // UI contorl for time left text field
    @IBOutlet weak var timeInput: UITextField!
    
    
    // MARK: - System methods
    
    /*
     Init
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MainCollectionController.setBackground(currentView: view)
        
        todoInput.becomeFirstResponder()
        todoInput.text = name
        timeInput.text = String(time ?? 30)
        
        if name != nil{
            navigationItem.title = "Edit"
        }
    }
    
    
    /*
     Deselect cell
     @parameter tableView: current table view
     @parameter didSelectRowAt: cell position
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - UIButton action
    
    /*
     Execute when press "done" button
     @parameter: sender: message when press button(empty in default)
     */
    @IBAction func done(_ sender: Any) {
        if !todoInput.text!.isEmpty, !timeInput.text!.isEmpty, Int(timeInput.text!) != nil{
            if self.name != nil{
                delegate?.didEdit(name: todoInput.text!, time:Int(timeInput.text!)!)
            }
            else{
                delegate?.didAdd(name: todoInput.text!, time:Int(timeInput.text!)!)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
}
