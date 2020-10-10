//
//  EditController.swift
//  Pomodoro
//
//  Created by 金一成 on 2020/10/6.
//

import UIKit

protocol TodoDelegate {
    func didAdd(name:String, time:Int)
    func didEdit(name:String, time:Int)
}


class EditTableController: UITableViewController {
    
    var delegate:TodoDelegate?
    var name:String?
    var time:Int?

    @IBOutlet weak var todoInput: UITextField!
    @IBOutlet weak var timeInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoInput.becomeFirstResponder()
        todoInput.text = name
        timeInput.text = String(time ?? 30)
        
        if name != nil{
            navigationItem.title = "Edit"
        }
    }

    @IBAction func done(_ sender: Any) {
        if !todoInput.text!.isEmpty{
            if self.name != nil{
                delegate?.didEdit(name: todoInput.text!, time:Int(timeInput.text!)!)
            }
            else{
                delegate?.didAdd(name: todoInput.text!, time:Int(timeInput.text!)!)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

}
