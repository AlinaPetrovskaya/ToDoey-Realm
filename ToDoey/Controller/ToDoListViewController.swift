//
//  ViewController.swift
//  ToDoey
//
//  Created by Alina Petrovskaya on 13.02.2021.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    let itemArray = ["sdfsdfdf", "sdsdf", "asdsdsd"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: Actions
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        addAlertShow(title: "Add New Todoey Item")
    }
    
    
    // MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark ? .none : .checkmark
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

