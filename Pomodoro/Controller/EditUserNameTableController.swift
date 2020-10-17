//
//  EditUserNameTableController.swift
//  Pomodoro
//
//  Created by 金一成 on 2020/10/16.
//

import UIKit
import Alamofire
import SwiftyJSON

class EditUserNameTableController: UITableViewController {

    private let updateUserNameURL = "http://api.cervidae.com.au:8080/users"
    
    @IBOutlet weak var editNameInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MainMenuController.setBackground(currentView: view)
        
        editNameInput.becomeFirstResponder()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(EditUserNameTableController.done(sender:)))
         self.navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc func done(sender: Any){
        if !editNameInput.text!.isEmpty{
            LoginController.userName = editNameInput.text!
            updateUserName(newName: LoginController.userName)
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    func updateUserName(newName: String){
        let paras = ["username": newName, "score": String(Int(LoginController.currentScore))]
        AF.request(updateUserNameURL, method: .post, parameters: paras).responseJSON{
            response in
            if let json = response.value{
                let message = JSON(json)
                if message["success"] == 1{
                    print("update name success")
                    print(message)
                }
                else{
                    print("update name error")
                }
            }
        }
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
