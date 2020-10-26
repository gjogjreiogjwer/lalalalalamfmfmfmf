//
//  AccountTableController.swift
//  Pomodoro
//
//  Created by 金一成 on 2020/10/16.
//

import UIKit

/*
 Account interface
 */
class AccountTableController: UITableViewController {

    // UI contorl for account name label
    @IBOutlet weak var accountNameLabel: UILabel!
    
    // UI contorl for score label
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    // MARK: - System methods

    /*
     Init
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        accountNameLabel.text = LoginController.userName
        scoreLabel.text = String(Int(LoginController.currentScore))
        logout()
        MainCollectionController.setBackground(currentView: view)
    }
    
    
    /*
     Set account name
     @parameter animated: perform animation or not
     */
    override func viewWillAppear(_ animated: Bool) {
        accountNameLabel.text = LoginController.userName
    }
    
    
    /*
     Deselect cell
     @parameter tableView: current table view
     @parameter didSelectRowAt: cell position
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - Helper
    
    /*
     Logout
     */
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
    
    
    /*
     Tap gesture when press "logout" button
     */
    @objc func tapped(){
        performSegue(withIdentifier: "logout", sender: nil)
    }
    
}
