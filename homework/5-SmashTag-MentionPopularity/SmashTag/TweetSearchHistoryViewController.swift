//
//  TweetSearchHistoryViewController.swift
//  SmashTag
//
//  Created by Dong, Vincent on 10/7/17.
//  Copyright © 2017 Dong, Vincent. All rights reserved.
//

import UIKit

//ASSIGNMENT 4 TASK 8
class TweetSearchHistoryViewController: UITableViewController {
    
    var searches: [String]! {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func viewDidLoad() {
        self.title = "Recent Searches"
        self.tabBarItem.title = "Recent Searches 1"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searches = SearchHistory.read()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searches.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Search History Cell", for: indexPath)

        cell.textLabel?.text = searches[indexPath.row]

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Search From History" {
            if let tweetsMVC = segue.destination as? SmashTweetTableViewController {
                tweetsMVC.searchText = (sender as? UITableViewCell)?.textLabel?.text
            }
        }
        
        if segue.identifier == "Show Popularity" {
            if let popularityMVC = segue.destination as? MentionsPopularityTableViewController {
                popularityMVC.searchTerm = (sender as? UITableViewCell)?.textLabel?.text
            }
        }
    }
}
