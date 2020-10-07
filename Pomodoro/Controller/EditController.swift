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


class EditController: UITableViewController {
    
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
                delegate?.didEdit(name: todoInput.text!, time:Int(timeInput.text!) ?? 30)
            }
            else{
                delegate?.didAdd(name: todoInput.text!, time:Int(timeInput.text!) ?? 30)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
