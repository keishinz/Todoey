//
//  ViewController.swift
//  Todoey
//
//  Created by Keishin CHOU on 2019/09/30.
//  Copyright © 2019 Keishin CHOU. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    /******************************************************************/
    //MARK: - Constants and Variables
    /******************************************************************/
    
    var itemArray = [Item]()

    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    
    /******************************************************************/
    //MARK: - View Life Circles
    /******************************************************************/
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print(self.dataFilePath!)
        loadItems()
    }
    
    /******************************************************************/
    //MARK: - TableView Datasource Methods
    /******************************************************************/
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    /******************************************************************/
    //MARK: - TableView Delegate Methods
    /******************************************************************/
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /******************************************************************/
    //MARK: - Add new Items with bar button
    /******************************************************************/
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var todoItem = UITextField()
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

            let newItem = Item()
            
            newItem.title = todoItem.text!
            self.itemArray.append(newItem)
            
            self.saveItems()
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Creat new item."
            if alertTextField.text != nil {
                todoItem = alertTextField
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    /******************************************************************/
    //MARK: - Model Manuplation Methods
    /******************************************************************/
    
    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("ERROR decoding item array, \(error)")
            }
        }
    }
    
    func saveItems() {
        
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
    }
}

