//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var todoItems: Results<Item>?
    var realm = try! Realm()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //        loadItems()
        searchBar.delegate = self
    }
    
    // MARK: - Add New Items
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
        
        //        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        //
        //        if let oldPredicate = predicate {
        //            request.predicate = NSCompoundPredicate(type: .and, subpredicates: [oldPredicate, categoryPredicate])
        //        } else {
        //            request.predicate = categoryPredicate
        //        }
        //
        //
        //        do {
        //            itemArray = try context.fetch(request)
        //        } catch {
        //            print("Error loading data from DB. \(error)")
        //        }
        tableView.reloadData()
    }
}


// MARK: - Tableview Datasource Methods
extension ToDoListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell")!
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
                    //                    realm.delete(item)
                    item.done.toggle()
                }
            } catch {
                print("Error updating item done status. \(error)")
            }
            tableView.reloadData()
        }
        
        //        if todoItems?[indexPath.row].done == true {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //        } else {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        //        }
        //        tableView.deselectRow(at: indexPath, animated: true)
        //        saveItems()
    }
}


// MARK: - SearchBar delegate methods
extension ToDoListViewController : UISearchBarDelegate {
    //    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    //        let request : NSFetchRequest<Item> = Item.fetchRequest()
    //        let searchPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
    //        request.predicate = searchPredicate
    //        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
    //        loadItems(with: request, predicate: searchPredicate)
    //    }
    //
    //    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    //        if searchBar.text?.count == 0 {
    //            loadItems()
    //            DispatchQueue.main.async {
    //                searchBar.resignFirstResponder()
    //            }
    //        }
    //    }
}
