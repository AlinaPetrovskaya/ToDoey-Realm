//
//  Category.swift
//  ToDoey
//
//  Created by Alina Petrovskaya on 22.02.2021.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
