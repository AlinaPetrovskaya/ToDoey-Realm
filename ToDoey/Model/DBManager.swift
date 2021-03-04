//
//  DBManager.swift
//  ToDoey
//
//  Created by Alina Petrovskaya on 14.02.2021.
//

import UIKit
import CoreData
import RealmSwift

class DBManager {
    
    let realm = try! Realm()
    
    lazy var todoItems: Results<Item> = realm.objects(Item.self)
    lazy var categoryArray: Results<Category> = realm.objects(Category.self)
    let typeOfController: TypeOfController
    
    init (for controller: TypeOfController,
          searchText: String? = nil,
          with category: Category? = nil) {
        
        typeOfController = controller
        loadItems(searchText: searchText, with: category)
    }
    
    
    func loadItems(searchText: String? = nil, with category: Category? = nil) {
        
        switch typeOfController {
        
        case .CategoryController:
            let categories = realm.objects(Category.self)
            categoryArray = categories
            
        case .ItemController:
            
            guard let items = category?.items.sorted(byKeyPath: "dateCreated", ascending: true) else { return }
            todoItems = items
            
            if let searchText = searchText {
                todoItems = todoItems.filter("title CONTAINS[cd] %@", searchText).sorted(byKeyPath: "dateCreated", ascending: true)
            }
        }
    }
    
    
    func save(item: Item? = nil, with category: Category? = nil) {
        do {
            try realm.write {
        
                switch typeOfController {
                case .CategoryController:
                    guard let safeCategory = category else { return }
                    realm.add(safeCategory)
                    
                case .ItemController:
                    guard let safeItem = item else { return }
                    category?.items.append(safeItem)
                    realm.add(safeItem)
                }
            }
        } catch {
            print ("Error saving array into DB: \(error.localizedDescription)")
        }
    }
}
