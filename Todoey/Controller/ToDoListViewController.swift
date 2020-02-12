//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var todoItems: Results<Item>?
    var realm = try! Realm()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
    }
    

    
    // MARK: - Override functions
    override func deleteModel(at indexPath: IndexPath) {
        // TODO: code to delete the item at the given indexPath
        if let itemToBeDeleted = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(itemToBeDeleted)
                }
            } catch {
                print("Failed to delete the item. \(error)")
            }
        }
    }
}


// MARK: - Tableview Datasource Methods
extension ToDoListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let color = UIColor(hexString: selectedCategory!.backgroundColor)!
        
        if let backgroundColor = color.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(todoItems!.count)) {
            cell.backgroundColor = backgroundColor
            cell.textLabel?.textColor = ContrastColorOf(backgroundColor, returnFlat: true)
        }
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items found yet"
            cell.accessoryType = .none
        }
        return cell
    }
}

// MARK: - Tableview Delegate Methods
extension ToDoListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done.toggle()
                }
            } catch {
                print("Error updating item done status. \(error)")
            }
            tableView.reloadData()
        }
    }
}

// MARK: - SearchBar delegate methods
extension ToDoListViewController : UISearchBarDelegate {
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            let searchPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            todoItems = todoItems?.filter(searchPredicate).sorted(byKeyPath: "dateCreated", ascending: true)
        }
    
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchBar.text?.count == 0 {
                loadItems()
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }
            }
        }
}

// MARK: - CRUD Data Maninpulation Methods
extension ToDoListViewController {
    // MARK: - Add new Items
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alertController = UIAlertController(title: "Add new Todoey", message: "", preferredStyle: .alert)
        let addTodoeyAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Failed to save items. \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        alertController.addAction(addTodoeyAction)
        alertController.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new item"
            textField = alertTextField
        }
        present(alertController, animated: true, completion: nil)
    }
   
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}
