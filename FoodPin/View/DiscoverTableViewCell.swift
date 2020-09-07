//
//  DiscoverTableViewCell.swift
//  FoodPin
//
//  Created by 王冠之 on 2020/9/6.
//  Copyright © 2020 Wangkuanchih. All rights reserved.
//

import UIKit

class DiscoverTableViewCell: UITableViewCell {
    
    @IBOutlet var discoverName: UILabel!
    @IBOutlet var discoverType: UILabel!
    @IBOutlet var discoverImage: UIImageView!
    @IBOutlet var discoverPhone: UILabel!
    @IBOutlet var discoverLocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
