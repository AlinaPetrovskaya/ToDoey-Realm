//
//  CategoryViewController.swift
//  ToDoey
//
//  Created by Alina Petrovskaya on 17.02.2021.
//
import UIKit
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    var dbManagerWrapper = DBManagerWrapper(for: .CategoryController)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        guard let navBar = navigationController?.navigationBar
        else { fatalError("Navigation bar doesn't exist") }
        
        let navBarColor                 = #colorLiteral(red: 0.417593956, green: 0.5600294471, blue: 0.9730384946, alpha: 1)
        navBar.backgroundColor          = navBarColor
        navBar.barTintColor             = navBarColor
        navBar.tintColor                = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString
                                            .Key
                                            .foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
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
        cell.backgroundColor = UIColor(hexString: item?.colour ?? "5877F6")
        
        guard let safeBackgroundColor = cell.backgroundColor else { return cell }
        cell.textLabel?.textColor = ContrastColorOf(safeBackgroundColor, returnFlat: true)
        
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
}

