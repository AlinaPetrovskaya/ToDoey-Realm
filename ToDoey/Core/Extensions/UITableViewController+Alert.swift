//
//  UIViewController+Allert.swift
//  ToDoey
//
//  Created by Alina Petrovskaya on 13.02.2021.
//

import UIKit

extension UITableViewController {
    func addAlertShow(title: String, completion: @escaping ((String) -> ())) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        var newItemTitle = UITextField()
        
        alert.addTextField { textField in
            textField.placeholder = "Create new item"
            newItemTitle = textField
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            guard let safeText = newItemTitle.text, newItemTitle.text != "" else { return }
                completion(safeText)
            }
        
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
