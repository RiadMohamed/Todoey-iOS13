//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Riad Mohamed on 2/10/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    
    // MARK: - Properties
    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.rowHeight = 80
    }
    
    // MARK: - Override functions
    override func deleteModel(at indexPath: IndexPath) {
        if let categoryToBeDeleted = categories?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(categoryToBeDeleted)
                }
            } catch {
                print("Failed to delete the categroy. \(error)")
            }
        }
    }
}

// MARK: - Tableview Datasource Methods
extension CategoryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No category name added yet"
        return cell
    }
}

// MARK: - Tableview Delegate Methods
extension CategoryViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! ToDoListViewController
        let indexPath = tableView.indexPathForSelectedRow
        destVC.selectedCategory = categories?[indexPath!.row]
    }
}

// MARK: - CRUD Data Manipulation Methods
extension CategoryViewController {
    // MARK: - Add new Categories
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alertController = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
        }
        
        alertController.addAction(action)
        alertController.addTextField { (field) in
            textField = field
            field.placeholder = "Add new category"
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
    }
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving categories. \(error)")
        }
        tableView.reloadData()
    }
}
