//
//  DiscoverTableViewController.swift
//  FoodPin
//
//  Created by 王冠之 on 2020/9/2.
//  Copyright © 2020 Wangkuanchih. All rights reserved.
//

import UIKit
import CloudKit

class DiscoverTableViewController: UITableViewController {
    
    var restaurants: [CKRecord] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.cellLayoutMarginsFollowReadableWidth = true
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Configure navigation bar appearance
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        if let customFont = UIFont(name: "Georgia", size: 40.0) {
            navigationController?.navigationBar.largeTitleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor(red: 231, green: 76, blue: 60), NSAttributedString.Key.font: customFont ]
        }
        
        fetchRecordsFromCloud()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoverCell", for: indexPath)
        let restaurant = restaurants[indexPath.row]
        cell.textLabel?.text = restaurant.object(forKey: "name") as? String
        if let image = restaurant.object(forKey: "image"), let imageAsset = image as? CKAsset {
            if let imageData = try? Data.init(contentsOf: imageAsset.fileURL!) {
                cell.imageView?.image = UIImage(data: imageData)
            }
        }

        return cell
    }
    
    func fetchRecordsFromCloud() {
        
        // Fetch data using Convenience API
        let cloudContainer = CKContainer.default()
        let publicDatabase = cloudContainer.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Restaurant", predicate: predicate)
        publicDatabase.perform(query, inZoneWith: nil) { (results, error) in
            if let error = error {
                print("Wrong Error", error)
                return
            }
            if let results = results {
                print("Completed the download of Restaurant data")
                self.restaurants = results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }

    }
}
