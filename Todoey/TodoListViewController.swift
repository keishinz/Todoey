//
//  ViewController.swift
//  Todoey
//
//  Created by Keishin CHOU on 2019/09/30.
//  Copyright © 2019 Keishin CHOU. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray =  ["Find Milk", "Buy Eggs", "Destroy Dragons"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //MARK - Tablevire Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.none {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK - Add new Items with bar button
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var todoItem = UITextField()
        //var todoText: String

        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //print(alertTextField.text)
            //print(todoText.text!)
            if todoItem.text != "" {
              self.itemArray.append(todoItem.text!)
            }
            self.tableView.reloadData()  
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Creat new item."
            todoItem = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }


}
