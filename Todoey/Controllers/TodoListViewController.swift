//
//  ViewController.swift
//  Todoey
//
//  Created by Keishin CHOU on 2019/09/30.
//  Copyright © 2019 Keishin CHOU. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController {

    /******************************************************************/
    //MARK: - Constants and Variables
    /******************************************************************/
    
    let realm = try! Realm()
    var todoItems: Results<Item>?
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
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
        
        tableView.rowHeight = 80.0
        searchBar.delegate = self
    }
    
    /******************************************************************/
    //MARK: - TableView Datasource Methods
    /******************************************************************/
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                try realm.write {
                    realm.delete(todoItems![indexPath.row])
                }
            } catch {
                print ("ERROR deleting category, \(error)")
            }
            loadItems()
        }
    }
    
    /******************************************************************/
    //MARK: - Add new Items with bar button
    /******************************************************************/
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var todoItem = UITextField()
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Creat new item."
            todoItem = alertTextField
        }

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let str = todoItem.text, !str.isEmpty, let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = str
                        print("\(newItem.title) is created at \(newItem.createdTime)")
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new item, \(error)")
                }
                self.tableView.reloadData()
            }
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
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let itemForDeletion = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print ("ERROR deleting todo item, \(error)")
            }
        }
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
