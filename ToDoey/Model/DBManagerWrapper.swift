//
//  DBManagerWrapper.swift
//  ToDoey
//
//  Created by Alina Petrovskaya on 21.02.2021.
//

import UIKit
import RealmSwift
import ChameleonFramework

enum TypeOfController: Int {
    case CategoryController
    case ItemController
}

class DBManagerWrapper {
    private let dbManager: DBManager
    
    init(for typeOfController: TypeOfController, searchRequest: String? = nil, with category: Category? = nil) {
        dbManager = DBManager(for: typeOfController, searchText: searchRequest, with: category)
    }
    
    func getNumberOfItems() -> Int {
        switch dbManager.typeOfController {
        case .CategoryController:
            return dbManager.categoryArray.count
            
        case .ItemController:
            return dbManager.todoItems.count
        }
    }
    
    func appendNewItem(with title: String, selectedCategory: Category? = nil) {
        
        switch dbManager.typeOfController {
        case .CategoryController:
            let category    = Category()
            category.name   = title
            category.colour = UIColor.randomFlat().hexValue()
            
            dbManager.save(with: category)
            
        case .ItemController:
            guard let selectedCategory = selectedCategory else { return }
            let item         = Item()
            item.title       = title
            item.done        = false
            item.dateCreated = Date()
            item.colour      = UIColor.randomFlat().hexValue()
            
            dbManager.save(item: item, with: selectedCategory)
        }
    }
    
    func getItemForCell(for row: Int) -> Object {
        switch dbManager.typeOfController {
        case .CategoryController:
            return dbManager.categoryArray[row]
            
        case .ItemController:
            return dbManager.todoItems[row]
        }
    }
    
    func loadItems(searchText: String? = nil, with category: Category? = nil) {
        dbManager.loadItems(searchText: searchText, with: category)
    }
    
    func deleteItems(for row: Int) {
        do {
            try dbManager.realm.write {
            
                switch dbManager.typeOfController {
                case .CategoryController:
                    dbManager.realm.delete(dbManager.categoryArray[row])
                    
                case .ItemController:
                    dbManager.realm.delete(dbManager.todoItems[row])
                }
            }
        } catch {
            print("Error saving updated item: \(error.localizedDescription)")
        }
    }
    
    func updateItem(for row: Int) {
        switch dbManager.typeOfController {
        case .CategoryController:
            break
            
        case .ItemController:
            do {
                try dbManager.realm.write {
                    dbManager.todoItems[row].done = !dbManager.todoItems[row].done
                }
            } catch {
                print("Error saving updated item: \(error.localizedDescription)")
            }
        }
    }
}


