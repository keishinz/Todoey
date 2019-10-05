//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Keishin CHOU on 2019/10/05.
//  Copyright © 2019 Keishin CHOU. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    //**************************************************//
    //MARK: - Constants and Variables
    //**************************************************//
    
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    //**************************************************//
    //MARK: - View Life Circles
    //**************************************************//
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadCategory()
    }
    
    //**************************************************//
    // MARK: - TableView Datasource Methods
    //**************************************************//
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categories[indexPath.row]
        
        cell.textLabel?.text = category.name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
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
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }

    //**************************************************//
    // MARK: - Model Manuplation Methods
    //**************************************************//
    
    func loadCategory() {
        
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categories = try context.fetch(request)
        } catch {
            print("ERROR loading context, \(error)")
        }
    }
    
    func saveCategory() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
    }
    
    //**************************************************//
    // MARK: - Button Methods
    //**************************************************//

    @IBAction func addCategoryButton(_ sender: UIBarButtonItem) {
        
        var category = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = category.text!
                        
            self.categories.append(newCategory)
            self.saveCategory()
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Creat new category."
            category = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
