//
//  UINavigationController+Ext.swift
//  FoodPin
//
//  Created by 王冠之 on 2020/8/12.
//  Copyright © 2020 Wangkuanchih. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    open override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
    
}
