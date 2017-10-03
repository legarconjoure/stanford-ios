//
//  TweesTableViewController.swift
//  ListView
//
//  Created by Dong, Vincent on 8/4/17.
//  Copyright © 2017 Dong, Vincent. All rights reserved.
//

import UIKit
import Twitter

class TweesTableViewController: UITableViewController {

    var tweets = Array<[Twitter.Tweet]>()
    
    var searchText: String = "#stanford"
//    {
//        didSet {
//            print(newValue)
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//            Twitter.Request(search: (self?.searchText)!, count: 20).fetchTweets({ tweets -> Void in
//                self?.tweets.append(tweets)
//                print(tweets)
//            })
//        }
        print("view did load")
        Twitter.Request(search: "#stanford", count: 20).fetchTweets { tweets in
            print(tweets)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweets[section].count
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */
}
