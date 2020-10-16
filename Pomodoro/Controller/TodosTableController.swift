//
//  TodosController.swift
//  Pomodoro
//
//  Created by 金一成 on 2020/9/30.
//

import UIKit
import RealmSwift

class TodosTableController: UITableViewController {
    
    private var row = 0
    private var datas: Results<Data>?
    private let realm = try! Realm()

    
    // MARK: - override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datas = realm.objects(Data.self)
        
        MainMenuController.setBackground(currentView: view)
    }
    
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        editButtonItem.title = isEditing ? "Done" : "Edit"
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return datas?.count ?? 0
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todo", for: indexPath) as! TodoCell

        if let datas = datas{
            cell.todo.text = datas[indexPath.row].name
            cell.leftTime.text = String(datas[indexPath.row].leftTime)
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        do{
            try realm.write{
                realm.delete(datas![indexPath.row])
            }
        }catch{
            print(error)
        }
        tableView.reloadData()
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
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

// MARK: - Database

extension TodosTableController: TodoDelegate, TimerDelegate, UISearchBarDelegate{
    
    private func saveData(data:Data){
        do{
            try realm.write{
                realm.add(data)
            }
        }catch{
            print(error)
        }
    }
    
    
    func didAdd(name: String, time: Int) {
        let data = Data()
        data.name = name
        data.leftTime = time
        saveData(data: data)
        tableView.reloadData()
    }
    
    
    func didEdit(name:String, time: Int){
        do{
            try realm.write{
                datas![row].name = name
                datas![row].leftTime = time
            }
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
    
    
    func didUpdateTime(time: Int) {
        do{
            try realm.write{
                datas![row].leftTime = time
            }
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
    
    
    // MARK: - Search bar
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        datas = realm.objects(Data.self).filter("name CONTAINS %@", searchBar.text!).sorted(byKeyPath: "leftTime", ascending: false)
        tableView.reloadData()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.isEmpty{
            datas = realm.objects(Data.self)
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
