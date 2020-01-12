//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = ["Find Mike", "Buy Eggs", "Destroy Dragon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Add New Items
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alertController = UIAlertController(title: "Add new Todoey", message: "", preferredStyle: .alert)
        let addTodoeyAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
//            print("Success!!")
//            print(textField.text ?? "No text entered")
            self.itemArray.append(textField.text!)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        alertController.addAction(addTodoeyAction)
        alertController.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new item"
            textField = alertTextField
//            print(alertTextField.text)
        }
        present(alertController, animated: true, completion: nil)
    }
    
}


// MARK: - Tableview Datasource Methods
extension ToDoListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell")!
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
}

// MARK: - Tableview Delegate Methods
extension ToDoListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        let currentCell = tableView.cellForRow(at: indexPath)!
        
        if currentCell.accessoryType == .checkmark {
            currentCell.accessoryType = .none
        } else {
            currentCell.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
