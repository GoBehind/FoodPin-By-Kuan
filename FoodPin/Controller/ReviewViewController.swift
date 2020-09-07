//
//  ReviewViewController.swift
//  FoodPin
//
//  Created by 王冠之 on 2020/8/16.
//  Copyright © 2020 Wangkuanchih. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
    
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var rateButtons: [UIButton]!
    var restaurant: RestaurantMO!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let restaurantImage = restaurant.image {
            backgroundImageView.image = UIImage(data: restaurantImage as Data)
        }
        
        //模糊效果
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        let moveRightTransform = CGAffineTransform.init(translationX: 600, y: 0)
        let scaleUpTransform = CGAffineTransform.init(scaleX: 5.0, y: 5.0)
        let moveScaleTransform = scaleUpTransform.concatenating(moveRightTransform)
        for rateButton in rateButtons {
            rateButton.transform = moveScaleTransform
            rateButton.alpha = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var delaytime: Double = 0.1
        for btn in 0...4 {
            UIView.animate(withDuration: 0.8, delay: delaytime, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.3, options: [], animations: {
                self.rateButtons[btn].alpha = 1.0
                self.rateButtons[btn].transform = .identity
            }, completion: nil)
            delaytime += 0.05
        }
    }

}
