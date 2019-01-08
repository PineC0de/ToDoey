//
//  Item.swift
//  ToDoey
//
//  Created by Travis Goins on 12/28/18.
//  Copyright © 2018 Travis Goins. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
   @objc dynamic var dateCreated : Date?
   @objc dynamic var title : String = ""
   @objc dynamic var done : Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
