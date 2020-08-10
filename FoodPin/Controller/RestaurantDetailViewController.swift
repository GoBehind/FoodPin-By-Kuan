//
//  RestaurantDetailViewController.swift
//  FoodPin
//
//  Created by 王冠之 on 2020/4/16.
//  Copyright © 2020 Wangkuanchih. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UIViewController {

    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantTypeLabel: UILabel!
    @IBOutlet weak var restaurantLocationLabel: UILabel!
    @IBOutlet weak var restaurantImageView: UIImageView!
    var restaurant = Restaurant()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantNameLabel.text = restaurant.name
        restaurantTypeLabel.text = restaurant.type
        restaurantLocationLabel.text = restaurant.location
        restaurantImageView.image = UIImage(named: restaurant.image)
        
        navigationItem.largeTitleDisplayMode = .never
    }
}
