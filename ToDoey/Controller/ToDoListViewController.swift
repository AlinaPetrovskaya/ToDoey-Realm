//
//  ViewController.swift
//  ToDoey
//
//  Created by Alina Petrovskaya on 13.02.2021.
//

import UIKit
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    private var dbManadgerWrapper: DBManagerWrapper?
    
    var selectedCategory: Category? {
        didSet {
            dbManadgerWrapper = DBManagerWrapper(for: .ItemController, with: selectedCategory)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        title = selectedCategory?.name
        
        if let categoryTextColour = selectedCategory?.colour, let categoryColour = UIColor(hexString: categoryTextColour) {
            guard let navBar = navigationController?.navigationBar
            else { fatalError("Navigation bar doesn't exist") }
            
            navBar.backgroundColor                    = categoryColour
            navBar.tintColor                          = ContrastColorOf(categoryColour, returnFlat: true)
            navBar.largeTitleTextAttributes           = [NSAttributedString
                                                            .Key
                                                            .foregroundColor: ContrastColorOf(categoryColour, returnFlat: true)]
            searchBar.barTintColor                    = categoryColour
            searchBar.searchTextField.backgroundColor = .white
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
        let cell           = super.tableView(tableView, cellForRowAt: indexPath)
        let item           = dbManadgerWrapper?.getItemForCell(for: indexPath.row) as? Item
        let numberOfItems  = CGFloat(dbManadgerWrapper?.getNumberOfItems() ?? 0)
        let сategoryColour = UIColor(hexString: selectedCategory?.colour ?? "5877F6")
        
        cell.textLabel?.text = item?.title
        cell.accessoryType   = item?.done ?? false ? .checkmark : .none
        cell.backgroundColor = сategoryColour?.darken(byPercentage: CGFloat(indexPath.row) / numberOfItems)
        
        guard let safeBackgroundColor = cell.backgroundColor  else { return cell }
        
        cell.textLabel?.textColor = ContrastColorOf(safeBackgroundColor, returnFlat: true)
        cell.tintColor            = ContrastColorOf(safeBackgroundColor, returnFlat: true)
        
        
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

