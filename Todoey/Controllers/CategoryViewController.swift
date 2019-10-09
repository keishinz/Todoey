//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Keishin CHOU on 2019/10/05.
//  Copyright © 2019 Keishin CHOU. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    //**************************************************//
    //MARK: - Constants and Variables
    //**************************************************//
    
    let realm = try! Realm()
    var categories: Results<Category>?

    //**************************************************//
    //MARK: - View Life Circles
    //**************************************************//
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        loadCategory()
        
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }
    
    //**************************************************//
    // MARK: - TableView Datasource Methods
    //**************************************************//
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let category = categories?[indexPath.row]

//        let colorHEX = UIColor.randomFlat().hexValue()
//        print(colorHEX)
        cell.backgroundColor = UIColor(hexString: category?.colorHEX ?? "#FFFFFF")
        cell.textLabel?.text = category?.name ?? "No category added yet."
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
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            do {
//                try realm.write {
//                    realm.delete(categories![indexPath.row])
//                }
//            } catch {
//                print ("ERROR deleting category, \(error)")
//            }
//            loadCategory()
//        }
//    }

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
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print ("ERROR deleting category, \(error)")
            }
        }
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
            
            if let str = category.text, !str.isEmpty {
                let newCategory = Category()
                newCategory.name = category.text!
                newCategory.colorHEX = UIColor.randomFlat().hexValue()
                self.save(category: newCategory)
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

