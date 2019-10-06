//
//  ViewController.swift
//  Todoey
//
//  Created by Keishin CHOU on 2019/09/30.
//  Copyright © 2019 Keishin CHOU. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    /******************************************************************/
    //MARK: - Constants and Variables
    /******************************************************************/
    
    let realm = try! Realm()
    var todoItems: Results<Item>?
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
            tableView.reloadData()
        }
    }

    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    /******************************************************************/
    //MARK: - View Life Circles
    /******************************************************************/
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print(dataFilePath)
        
        searchBar.delegate = self
    }
    
    /******************************************************************/
    //MARK: - TableView Datasource Methods
    /******************************************************************/
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No item added."
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
    }
    
    /******************************************************************/
    //MARK: - TableView Delegate Methods
    /******************************************************************/
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
//                    realm.delete(item)
                }
            } catch {
                print ("ERROR saving done status, \(error)")
            }
        }
        
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
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = todoItem.text!
                        print("\(newItem.title) is created at \(newItem.createdTime)")
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new item, \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Creat new item."
            //if alertTextField.text != nil {
                todoItem = alertTextField
            //}
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    /******************************************************************/
    //MARK: - Model Manuplation Methods
    /******************************************************************/
    
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}


/******************************************************************/
//MARK: - SearchBar Methods
/******************************************************************/

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "createdTime", ascending: false)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text!.isEmpty {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
