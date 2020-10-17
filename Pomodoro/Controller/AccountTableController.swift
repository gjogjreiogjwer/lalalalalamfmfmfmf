//
//  AccountTableController.swift
//  Pomodoro
//
//  Created by 金一成 on 2020/10/16.
//

import UIKit

class AccountTableController: UITableViewController {

  
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountNameLabel.text = LoginController.userName
        scoreLabel.text = String(Int(LoginController.currentScore))
        
        logout()

        MainMenuController.setBackground(currentView: view)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        accountNameLabel.text = LoginController.userName
    }
    
    func logout(){
        let button = UIButton(type:.system)
        button.frame = CGRect(x:10, y:150, width:100, height:30)
        button.frame.size.width = 200
        button.frame.size.height = 200
        button.center.x = tableView.center.x
        button.center.y = tableView.center.y + 80
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button.setTitle("Logout", for:.normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.addTarget(self, action:#selector(self.tapped), for:.touchUpInside)
        tableView.addSubview(button)
    }
    
    @objc func tapped(){
        performSegue(withIdentifier: "logout", sender: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "logout"{
            let vc = segue.destination as! LoginController
            vc.currentAccount = LoginController.userName
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



}
