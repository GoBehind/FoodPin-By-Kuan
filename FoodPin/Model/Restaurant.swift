//
//  Restaurant.swift
//  FoodPin
//
//  Created by 王冠之 on 2020/4/18.
//  Copyright © 2020 Wangkuanchih. All rights reserved.
//

import Foundation
class Restaurant {
    var name: String
    var type: String
    var location: String
    var image: String
    var isVisited: Bool
    
    init(name: String, type: String, location: String, image: String, isVisited: Bool) {
        self.name = name
        self.type = type
        self.location = location
        self.image = image
        self.isVisited = isVisited
    }
    
    convenience init() {
    self.init(name: "", type: "", location: "", image: "", isVisited: false)
    }
}
