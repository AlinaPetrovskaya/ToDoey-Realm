//
//  SwipeTableViewController.swift
//  ToDoey
//
//  Created by Alina Petrovskaya on 04.03.2021.
//

import UIKit
import SwipeCellKit


class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 70.0

    }
    
    // MARK: TableView Data Source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? SwipeTableViewCell else { return SwipeTableViewCell() }
        
        cell.delegate = self
        
        return cell
    }
    
    
// MARK: SwipeTableViewCellDelegate
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { [weak self] (action, indexPath) in
            self?.updateModel(at: indexPath)
        }

        deleteAction.image = UIImage(systemName: "trash")

        return [deleteAction]
    }

    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options            = SwipeTableOptions()
        options.expansionStyle = .destructive

        return options
    }

    func updateModel(at indexPath: IndexPath) {
        //upate Datamodel
    }

}
