//
//  TweetTableViewController.swift
//  SmashTag
//
//  Created by Dong, Vincent on 9/30/17.
//  Copyright © 2017 Dong, Vincent. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    
    // L09 Step 1: Define model
    // An array of an array of tweets
    // Why: for new fetches of tweets, put them in a new section
    private var tweets = [Array<Twitter.Tweet>]() {
        didSet {
            print(tweets)
        }
    }
    
    // Another thing in the model: search text. for example, hash tags #stanford
    var searchText: String? {
        didSet {
            // add search handling
            searchTextField?.text = searchText
            searchTextField?.resignFirstResponder()
            //when searching, refresh the table view and search
            lastTwitterRequest = nil
            tweets.removeAll()
            tableView.reloadData()
            searchForTweets()
            //so that if I am in a navigation controller, I can show the search term
            title = searchText
        }
    }
    
    func insertTweets(_ newTweets: [Twitter.Tweet]) {
        self.tweets.insert(newTweets, at: 0)
        self.tableView.insertSections([0], with: .fade)
    }
    
    // Step 3: Now have func to get a twitter request that matches the searchText
    private func twitterRequest() -> Twitter.Request? {
        if let query = searchText, !query.isEmpty {
            return Twitter.Request(search: query, count: 100)
        }
        
        return nil
    }
    
    private var lastTwitterRequest: Twitter.Request?
    private func searchForTweets() {
        if let request = lastTwitterRequest?.newer ?? twitterRequest() {
            lastTwitterRequest = request //if searching another term...
            request.fetchTweets { [weak self] newTweets in
                DispatchQueue.main.async {
                    if request == self?.lastTwitterRequest {
                        // L11: Make it more subclassable
//                        self?.tweets.insert(newTweets, at: 0)
                        //NOW need to tell the table view to insert these new tweets
//                        self?.tableView.insertSections([0], with: .fade)
                        
                        self?.insertTweets(newTweets)
                        self?.refreshControl?.endRefreshing()
                    }
                }
            }
        } else {
            self.refreshControl?.endRefreshing()
        }
    }

    // Step 2: for testing purpose
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            searchText = searchTextField.text
        }
        return true
    }

    @IBAction func refresh(_ sender: UIRefreshControl) {
        searchForTweets()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tweet", for: indexPath)

        let tweet = tweets[indexPath.section][indexPath.row]
//        cell.textLabel?.text = tweet.text
//        cell.detailTextLabel?.text = tweet.user.name
        
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }

        return cell
    }
    
    //try out table view delegate methods
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row % 2 == 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(tweets.count - section)"
    }
}
