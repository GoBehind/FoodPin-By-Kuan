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
    var spinner = UIActivityIndicatorView()
    private var imageCache = NSCache<CKRecord.ID, NSURL>()

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
        
        spinner.style = .large
        spinner.hidesWhenStopped = true
        view.addSubview(spinner)
        
        //定義旋轉指示器的layout
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                                        spinner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150.0),
                                        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        //啟用spinner
        spinner.startAnimating()
        
        //下拉更新元件
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.white
        refreshControl?.tintColor = UIColor.white
        refreshControl?.addTarget(self, action: #selector(fetchRecordsFromCloud), for: UIControl.Event.valueChanged)
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
        //設定cell
        let restaurant = restaurants[indexPath.row]
        cell.textLabel?.text = restaurant.object(forKey: "name") as? String
        //設定cell圖片
        cell.imageView?.image = UIImage(named: "photo")
        
        //檢查圖片是否存已儲存在快取中
        if let imageFileURL = imageCache.object(forKey: restaurant.recordID) {
            //從快取中取得圖片
            print("Get image from cache.")
            if let imageData = try? Data.init(contentsOf: imageFileURL as URL) {
                cell.imageView?.image = UIImage(data: imageData)
            }
        } else {
            //在背景從雲端取得圖片
            let publicDatabase = CKContainer.default().publicCloudDatabase
            let fetchRecordsImageOperation = CKFetchRecordsOperation(recordIDs: [restaurant.recordID])
            fetchRecordsImageOperation.queuePriority = .veryHigh
            fetchRecordsImageOperation.desiredKeys = ["image"]
            
            fetchRecordsImageOperation.perRecordCompletionBlock = {(record, recordID, error) in
                if let error = error {
                    print("Failed to get restaurant image: \(error.localizedDescription)")
                    return
                }
                if let restautantRecord = record,
                   let image = restautantRecord.object(forKey: "image"),
                   let imageAsset = image as? CKAsset {
                    if let imageData = try? Data.init(contentsOf: imageAsset.fileURL!) {
                        //將預設圖片以iCloud圖片取代
                        DispatchQueue.main.async {
                            cell.imageView?.image = UIImage(data: imageData)
                            cell.setNeedsLayout()
                        }
                        //加入圖片URL至快取
                        self.imageCache.setObject(imageAsset.fileURL! as NSURL, forKey: restaurant.recordID)
                    }
                }
            }
            publicDatabase.add(fetchRecordsImageOperation)
        }
        return cell
    }
    
    @objc func fetchRecordsFromCloud() {
        
        //更新之前移除目前的資料記錄
        restaurants.removeAll()
        tableView.reloadData()
        
        // 使用便利型API取得資料
        let cloudContainer = CKContainer.default()
        let publicDatabase = cloudContainer.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Restaurant", predicate: predicate)
        //依時間降冪排列
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        //以query建立查詢動作
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.desiredKeys = ["name"]
        queryOperation.queuePriority = .veryHigh
        queryOperation.resultsLimit = 50
        queryOperation.recordFetchedBlock = {(record) in
            self.restaurants.append(record)
        }
        
        queryOperation.queryCompletionBlock = {[unowned self](cursor, error) in
            if let error = error {
                print("Failed to get data from iCloud - \(error.localizedDescription)")
                return
            }
            print("Successfully retrieve the data from iCloud")
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                
                if let refreshControl = self.refreshControl {
                    if refreshControl.isRefreshing {
                        refreshControl.endRefreshing()
                    }
                }
                
                self.tableView.reloadData()
            }
        }
        //執行查詢
        publicDatabase.add(queryOperation)
    }
}
