//
//  ViewController.swift
//  ToDoey
//
//  Created by Alina Petrovskaya on 13.02.2021.
//

import UIKit
import SwipeCellKit

class ToDoListViewController: SwipeTableViewController {
    
    private var dbManadgerWrapper: DBManagerWrapper?
    
    var selectedCategory: Category? {
        didSet {
            dbManadgerWrapper = DBManagerWrapper(for: .ItemController, with: selectedCategory)
        }
    }
    
    // MARK: Actions
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        addAlertShow(title: "Add New Todoey Item") { [weak self] title in
            self?.dbManadgerWrapper?.appendNewItem(with: title, selectedCategory: self?.selectedCategory)
            self?.tableView.reloadData()
        }
    }
    
    override func updateModel(at indexPath: IndexPath) {
        dbManadgerWrapper?.deleteItems(for: indexPath.row)
    }
    
    // MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dbManadgerWrapper?.getNumberOfItems() ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let item = dbManadgerWrapper?.getItemForCell(for: indexPath.row) as? Item
        cell.textLabel?.text = item?.title
        cell.accessoryType = item?.done ?? false ? .checkmark : .none
        
        return cell
    }
    
// MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dbManadgerWrapper?.updateItem(for: indexPath.row)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}  

// MARK: UISearchBarDelegate
extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let safeText = searchBar.text, safeText != ""  else { return }
        dbManadgerWrapper?.loadItems(searchText: safeText, with: selectedCategory)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            dbManadgerWrapper?.loadItems(with: selectedCategory)
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            tableView.reloadData()
        }
    }
}

