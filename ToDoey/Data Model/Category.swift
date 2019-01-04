//
//  Category.swift
//  ToDoey
//
//  Created by Travis Goins on 12/28/18.
//  Copyright © 2018 Travis Goins. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
   
    @objc dynamic var name : String = ""
    let items = List<Item>()
}

