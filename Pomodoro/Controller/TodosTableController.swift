//
//  TodosController.swift
//  Pomodoro
//
//  Created by 金一成 on 2020/9/30.
//

import UIKit
import RealmSwift

/*
 Todos list interface
 */

class TodosTableController: UITableViewController {
    
    // Row of selected cell
    private var row = 0
    
    // Array of user data
    private var datas: Results<Data>?
    
    // Local storage database
    private let realm = try! Realm()

    
    // MARK: - System methods
    
    /*
     Init
     */
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(Realm.Configuration.defaultConfiguration.fileURL)
        datas = realm.objects(Data.self).filter("userName == '\(LoginController.userName)'")
    }
    
    
    /*
     Setting title of editing button
     @parameter animated: perform animation or not
     */
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        editButtonItem.title = isEditing ? "Done" : "Edit"
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
        return datas?.count ?? 0
    }

  
    /*
     Init cells
     @parameter tableView: current table view
     @parameter cellForItemAt: current cell
     @parameter indexPath: cell position
     @returns cell: Todo cell
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todo", for: indexPath) as! TodoCell
        if let datas = datas{
            cell.todo.text = datas[indexPath.row].name
            cell.leftTime.text = String(datas[indexPath.row].leftTime)
        }
        return cell
    }
    
    
    /*
     Delete cell
     @parameter tableView: current table view
     @parameter forRowAt: position of cuttent cell
     */
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        do{
            try realm.write{
                realm.delete(datas![indexPath.row])
            }
        }
        catch{
            print(error)
        }
        tableView.reloadData()
    }


    
    // MARK: - Navigation

    /*
     Transfer message to next pages
     @parameter segue: segue to which pages
     @parameter sender: message when segue button(empty in default)
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addTodo"{
            let vc = segue.destination as! EditTableController
            vc.delegate = self
        }
        else if segue.identifier == "editTodo"{
            let vc = segue.destination as! EditTableController
            let cell = sender as! TodoCell
            row = tableView.indexPath(for: cell)!.row
            vc.name = datas?[row].name
            vc.time = datas?[row].leftTime
            vc.delegate = self
        }
        else if segue.identifier == "timer"{
            let vc = segue.destination as! TimerController
            let cell = sender as! TodoCell
            row = tableView.indexPath(for: cell)!.row
            vc.time = Double(datas?[row].leftTime ?? 30)
            vc.delegate = self
        }
    }
}


// MARK: - Extension: implement TodoDelegate, TimerDelegate, UISearchBarDelegate

extension TodosTableController: TodoDelegate, TimerDelegate, UISearchBarDelegate{
    
    /*
     Save data into Realm database
     @parameter data: user data
     */
    private func saveData(data:Data){
        do{
            try realm.write{
                realm.add(data)
            }
        }catch{
            print(error)
        }
    }
    
    
    /*
     Get new task from EditTableController
     @parameter name: task name
     @parameter time: estimated task completion time
     */
    func didAdd(name: String, time: Int) {
        let data = Data()
        data.name = name
        data.leftTime = time
        data.userName = LoginController.userName
        saveData(data: data)
        tableView.reloadData()
    }
    
    
    /*
     Edit task from EditTableController
     @parameter name: task name
     @parameter time: estimated task completion time
     */
    func didEdit(name:String, time: Int){
        do{
            try realm.write{
                datas![row].name = name
                datas![row].leftTime = time
            }
        }
        catch{
            print(error)
        }
        tableView.reloadData()
    }
    
    
    /*
     Update left time from TimerController
     @parameter time: left time for task
     */
    func didUpdateTime(time: Int) {
        do{
            try realm.write{
                datas![row].leftTime = time
            }
        }
        catch{
            print(error)
        }
        tableView.reloadData()
    }
    
    
    // MARK: - Search bar
    
    /*
     Filter specific task based on task name
     */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        datas = realm.objects(Data.self).filter("userName == '\(LoginController.userName)' AND name CONTAINS %@", searchBar.text!).sorted(byKeyPath: "leftTime", ascending: false)
        tableView.reloadData()
    }
    
    
    /*
     Restore Todos when searchBar is empty
     */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.isEmpty{
            datas = realm.objects(Data.self).filter("userName == '\(LoginController.userName)'")
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
