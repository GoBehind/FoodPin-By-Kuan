//
//  WalkthroughViewController.swift
//  FoodPin
//
//  Created by 王冠之 on 2020/8/27.
//  Copyright © 2020 Wangkuanchih. All rights reserved.
//

import UIKit

class WalkthroughViewController: UIViewController, WalkthroughPageViewControllerDelegate {
    
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var nextButton: UIButton! {
        didSet {
            nextButton.layer.cornerRadius = 25.0
            nextButton.layer.masksToBounds = true
        }
    }
    @IBOutlet var skipButton: UIButton!
    var walkthroughPageViewController: WalkthroughPageViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func nextButtonTapped(sender: UIButton) {
        if let index = walkthroughPageViewController?.currentIndex {
            switch index {
            case 0...1:
                walkthroughPageViewController?.forwardPage()
            case 2:
                UserDefaults.standard.setValue(true, forKey: "hasViewWalkthrough")
                dismiss(animated: true, completion: nil)
            default:
                break
            }}
        update()
    }
    
    @IBAction func skipButtonTapped(sender: UIButton) {
        UserDefaults.standard.setValue(true, forKey: "hasViewWalkthrough")
        dismiss(animated: true, completion: nil)
    }
    
    func update() {
        if let index = walkthroughPageViewController?.currentIndex {
            switch index {
            case 0...1:
                nextButton.setTitle(NSLocalizedString("NEXT", comment: "NEXT"), for: .normal)
                skipButton.isHidden = false
            case 2:
                nextButton.setTitle(NSLocalizedString("GET STARTED", comment: "GET STARTED"), for: .normal)
                skipButton.isHidden = true
            default:
                break
            }
            pageControl.currentPage = index
        }
    }
    
    func didUpdatePageIndex(currentIndex: Int) {
        update()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let pageViewController = destination as? WalkthroughPageViewController {
            walkthroughPageViewController = pageViewController
            walkthroughPageViewController?.walkthroughDelegate = self
        }
    }

}
