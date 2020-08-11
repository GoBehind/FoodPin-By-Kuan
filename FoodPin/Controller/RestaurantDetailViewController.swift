//
//  RestaurantDetailViewController.swift
//  FoodPin
//
//  Created by 王冠之 on 2020/4/16.
//  Copyright © 2020 Wangkuanchih. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: RestaurantDetailHeaderView!

    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantTypeLabel: UILabel!
    @IBOutlet weak var restaurantLocationLabel: UILabel!
    @IBOutlet weak var restaurantImageView: UIImageView!
    var restaurant = Restaurant()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        restaurantNameLabel.text = restaurant.name
//        restaurantTypeLabel.text = restaurant.type
//        restaurantLocationLabel.text = restaurant.location
//        restaurantImageView.image = UIImage(named: restaurant.image)
        
        navigationItem.largeTitleDisplayMode = .never
        
        //設定頭部示圖
        headerView.nameLabel.text = restaurant.name
        headerView.typeLabel.text = restaurant.type
        headerView.headerImageView.image = UIImage(named: restaurant.image)
        headerView.heartImageView.isHidden = (restaurant.isVisited) ? false : true
        
    }
}
