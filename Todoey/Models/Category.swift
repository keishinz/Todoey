//
//  Category.swift
//  Todoey
//
//  Created by Keishin CHOU on 2019/10/06.
//  Copyright © 2019 Keishin CHOU. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    let items = List<Item>()
    
}

