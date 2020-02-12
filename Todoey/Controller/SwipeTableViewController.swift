//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Riad Mohamed on 2/12/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func deleteModel(at indexPath: IndexPath) {
        // to be used by the child classes to adjust their model accordingly
    }
}

// MARK: - TableView Datasource Methods
extension SwipeTableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }
}

// MARK: - SwipeCellKit Methods
extension SwipeTableViewController: SwipeTableViewCellDelegate {
     func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
         guard orientation == .right else { return nil }
         
         let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
             // handle action by updating model with deletion
            print("Item deleted.")
            self.deleteModel(at: indexPath)
         }
         deleteAction.image = UIImage(named: "delete")
         return [deleteAction]
     }
    
     func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
         var options = SwipeOptions()
         options.expansionStyle = .destructive
         options.transitionStyle = .reveal
         return options
     }
}
