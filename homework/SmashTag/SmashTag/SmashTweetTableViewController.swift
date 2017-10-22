//
//  SmashTweetTableViewController.swift
//  SmashTag
//
//  Created by Dong, Vincent on 10/1/17.
//  Copyright © 2017 Dong, Vincent. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class SmashTweetTableViewController: TweetTableViewController {
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    //L11 override the insertTweets
    override func insertTweets(_ newTweets: [Twitter.Tweet]) {
        super.insertTweets(newTweets)
        updateDatabase(with: newTweets)
    }
    
    private func updateDatabase(with tweets: [Twitter.Tweet]) {
        //L11: Background the update
        container?.performBackgroundTask { [weak self] context in
            for twitterInfo in tweets {
                _ = try? Tweet.findOrCreateTweet(matching: twitterInfo, in: context)
            }
            try? context.save()
            self?.printDatabaseStatistics()
        }
        
    }
    
    private func printDatabaseStatistics()  {
        if let context = container?.viewContext {
            context.perform {
                let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
                if let tweetCount = (try? context.fetch(request))?.count {
                    print("\(tweetCount) tweets")
                }
                if let tweeterCount = try? context.count(for: TwitterUser.fetchRequest()) {
                    print("\(tweeterCount) Twitter user")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Tweeters Mentioning Search Term" {
            if let tweetersMVC = segue.destination as? SmashTweetersTableViewController {
                tweetersMVC.mention = searchText
                tweetersMVC.container = container
            }
        }
        
        if segue.identifier == "Tweet Mentions" {
            if let tweetMentionsMVC = segue.destination as? TweetMentionsTableViewController,
                let cell = sender as? TweetTableViewCell {
                tweetMentionsMVC.tweet = cell.tweet
            }
        }
    }
}
