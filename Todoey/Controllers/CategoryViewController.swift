//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Keishin CHOU on 2019/10/05.
//  Copyright © 2019 Keishin CHOU. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    //**************************************************//
    //MARK: - Constants and Variables
    //**************************************************//
    
    //let realm = try! Realm()
    let realm = try! Realm()
    var categories: Results<Category>?

    //**************************************************//
    //MARK: - View Life Circles
    //**************************************************//
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        loadCategory()
    }
    
    //**************************************************//
    // MARK: - TableView Datasource Methods
    //**************************************************//
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categories?[indexPath.row]
        
        cell.textLabel?.text = category?.name ?? "No category added yet."
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
    }
    
    //**************************************************//
    // MARK: - TableView Delegate Methods
    //**************************************************//
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }

    //**************************************************//
    // MARK: - Model Manuplation Methods
    //**************************************************//
    
    func loadCategory() {
        
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context, \(error)")
        }
        tableView.reloadData()
    }
    
    //**************************************************//
    // MARK: - Button Methods
    //**************************************************//

    @IBAction func addCategoryButton(_ sender: UIBarButtonItem) {
        
        var category = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Creat new category."
            category = alertTextField
        }
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            if category.text!.isEmpty {
//                category.placeholder = "Please enter a category."
            } else {
                let newCategory = Category()
                newCategory.name = category.text!
                self.save(category: newCategory)
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
