//
//  Item.swift
//  Todoey
//
//  Created by Keishin CHOU on 2019/10/06.
//  Copyright © 2019 Keishin CHOU. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var done:Bool = false
    @objc dynamic var createdTime = NSDate.now
    
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

