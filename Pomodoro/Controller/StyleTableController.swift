//
//  StyleTableController.swift
//  Pomodoro
//
//  Created by 金一成 on 2020/10/10.
//

import UIKit

/*
 Style interface
 */
class StyleTableController: UITableViewController {
    
    // Style description
    var describe: UILabel = UILabel()
    
    // Array of styles
    private let styles = ["Normal", "Flip", "Microphone"]
    
    // last selected cell
    private var lastCell:StyleCell!

    
    // MARK: - System methods

    /*
     Init
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        MainCollectionController.setBackground(currentView: view)
    }
    
    
    /*
     Change current description
     @parameter animated: perform animation or not
     */
    override func viewWillDisappear(_ animated: Bool) {
        describe.text = "Current style: \(styles[TimerController.timerStyle])"
    }
    

    // MARK: - Table view data source

    /*
     @parameter tableView: current table view
     @returns: the number of sections
     */
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    
    /*
     @parameter tableView: current table view
     @parameter numberOfItemsInSection: row in which section
     @returns: the number of row
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return styles.count
    }

    
    /*
     Init cells
     @parameter tableView: current table view
     @parameter cellForItemAt: current cell
     @parameter indexPath: cell position
     @returns cell: Todo cell
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "style", for: indexPath) as! StyleCell
        cell.styleLabel.text = styles[indexPath.row]
        if indexPath.row == TimerController.timerStyle{
            cell.accessoryType = .checkmark
            lastCell = cell
        }
        return cell
    }
    
    
    /*
     Selected cell
     @parameter tableView: current table view
     @parameter didSelectRowAt: cell position
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! StyleCell
        lastCell.accessoryType = .none
        lastCell = cell
        cell.accessoryType = .checkmark
        TimerController.timerStyle = indexPath.row
        UserDefaults.standard.set(TimerController.timerStyle, forKey: "style")
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
