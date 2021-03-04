//
//  Item.swift
//  ToDoey
//
//  Created by Alina Petrovskaya on 22.02.2021.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    @objc dynamic var colour: String = ""
    var parentCategory = LinkingObjects (fromType: Category.self, property: "items")
}
