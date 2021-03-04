//
//  CategoryViewController.swift
//  ToDoey
//
//  Created by Alina Petrovskaya on 17.02.2021.
//
import UIKit

class CategoryViewController: SwipeTableViewController {
    var dbManagerWrapper = DBManagerWrapper(for: .CategoryController)
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        addAlertShow(title: "Add New Category") { [weak self] name in

                self?.dbManagerWrapper.appendNewItem(with: name)
                self?.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            let selectedCategory = dbManagerWrapper.getItemForCell(for: indexPath.row) as? Category
            destinationVC?.selectedCategory = selectedCategory
        }
    }
    
    override func updateModel(at indexPath: IndexPath) {
        dbManagerWrapper.deleteItems(for: indexPath.row)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return dbManagerWrapper.getNumberOfItems()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let item = dbManagerWrapper.getItemForCell(for: indexPath.row) as? Category
        cell.textLabel?.text = item?.name
        return cell
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
}
