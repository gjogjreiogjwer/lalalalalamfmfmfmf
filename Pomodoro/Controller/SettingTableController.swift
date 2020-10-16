//
//  SettingController.swift
//  Pomodoro
//
//  Created by 金一成 on 2020/10/10.
//

import UIKit

class SettingTableController: UITableViewController {
    
    private let aboutUsInfo = """
                    Group-W01/16-4
                    
                    Yicheng Jin
                    ChongZheng Zhao
                    Yuyang Wang
                    Runfeng Du
                    Tao Ge
                    Shuai Mou
                    """

    @IBOutlet weak var aboutUsCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        MainMenuController.setBackground(currentView: view)
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(SettingTableController.handleTapToAboutUs(sender:)))
        aboutUsCell.addGestureRecognizer(tap)
    }
    
    
    @objc func handleTapToAboutUs(sender:UITapGestureRecognizer) {
        if sender.state == .ended{
            showUs()
        }
    }
    
    
    private func showUs(){
        let info = UILabel()
        info.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        info.alpha = 0.5
        info.layer.cornerRadius = 5.0
        info.font = UIFont.systemFont(ofSize: 23)
        info.numberOfLines = 0
        info.text = aboutUsInfo
            
            
        info.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        info.textAlignment = .center
        tableView.addSubview(info)
        
        info.frame.size.width = 280
        info.frame.size.height = 250
        info.center.x = tableView.center.x
        info.center.y = tableView.frame.height + 200
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 10,
                       options: [],
                       animations: {
                        info.center.y -= 450
                       },
                       completion: nil)
        
        UIView.animate(withDuration: 0.5,
                       delay: 2,
                       options: .curveEaseIn) {
            info.center.y += 450
        } completion: { _ in
            info.removeFromSuperview()
        }
    }

    // MARK: - Table view data source

   

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
