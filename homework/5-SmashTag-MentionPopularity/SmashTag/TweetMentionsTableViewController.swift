//
//  TweetMentionsTableViewController.swift
//  SmashTag
//
//  Created by Dong, Vincent on 10/2/17.
//  Copyright © 2017 Dong, Vincent. All rights reserved.
//

import UIKit
import Twitter

class TweetMentionsTableViewController: UITableViewController {
    
    var tweet: Twitter.Tweet? {
        didSet {
            updateUI()
        }
    }

    private func updateUI() {
        assert(tweet != nil)
        print("hashtags: \(tweet!.hashtags)")
        print("urls: \(tweet!.urls)")
        print("mentions: \(tweet!.userMentions)")
        print("media: \(tweet!.media)")
        tableView.reloadData()
    }
    
    struct MentionType {
        private var index: Int
        
        var count: Int = 0
        var displayTexts: [String?] = []
        var sectionHeader: String? = nil
        
        init(tweet: Twitter.Tweet, index: Int) {
            self.index = index
            if let mentionType = MentionTypes(rawValue: index) {
                switch mentionType {
                case .media:
                    count = tweet.media.count
                    sectionHeader = count > 0 ? "Media Items" : nil
                    displayTexts = []
                case .hashtags:
                    count = tweet.hashtags.count
                    sectionHeader = count > 0 ? "Hashtags" : nil
                    displayTexts = tweet.hashtags.map { $0.keyword }
                case .urls:
                    count = tweet.urls.count
                    sectionHeader = count > 0 ? "URLs" : nil
                    displayTexts = tweet.urls.map { $0.keyword }
                case .userMentions:
                    count = tweet.userMentions.count
                    sectionHeader = count > 0 ? "User Mentions" : nil
                    displayTexts = tweet.userMentions.map { $0.keyword }
                }
            }
        }
    }
    
    enum MentionTypes: Int {
        case media = 0
        case hashtags = 1
        case urls = 2
        case userMentions = 3
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MentionType(tweet: tweet!, index: section).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if indexPath.section == MentionTypes.media.rawValue { // ASSIGNMENT 4 Task 2
            cell = tableView.dequeueReusableCell(withIdentifier: "Tweet Image Cell", for: indexPath)
            (cell as? TweetMentionsImageCellTableViewCell)?.mediaItem = tweet?.media[indexPath.row]
        } else if indexPath.section == MentionTypes.urls.rawValue {
            cell = tableView.dequeueReusableCell(withIdentifier: "Tweet URL Cell", for: indexPath) as! TweetMentionUrlTableViewCell
            cell.textLabel?.text = text(at: indexPath)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "Tweet Mentions Cell", for: indexPath)
            cell.textLabel?.text = text(at: indexPath)
        }
        
        return cell
    }
    
    // ASSIGNMENT 4 Task 2 & 3
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == MentionTypes.media.rawValue {
            let mediaItem = tweet?.media[indexPath.row] //can't use the cellForRowAt here b/c it's nil
            return tableView.bounds.width / CGFloat(mediaItem?.aspectRatio ?? 1.0)
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    private func text(at indexPath: IndexPath) -> String? {
        return MentionType(tweet: tweet!, index: indexPath.section).displayTexts[indexPath.row]
    }
    
    //ASSIGNMENT 4 Task 4
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return MentionType(tweet: tweet!, index: section).sectionHeader
    }
    
    //ASSIGNMENT 4 Task 5
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Search For Mention" {
            if let searchMentionMVC = segue.destination as? SmashTweetTableViewController,
                let cell = sender as? UITableViewCell {
                searchMentionMVC.searchText = cell.textLabel?.text
            }
        }
        
        if segue.identifier == "View Large Image" {
            if let imageMVC = segue.destination as? TweetLargeImageViewController,
                let cell = sender as? TweetMentionsImageCellTableViewCell {
                imageMVC.image = cell.imageView?.image
            }
        }
    }
    
    //ASSIGNMENT 4 Task 6: Open URL in Safari
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == MentionTypes.urls.rawValue { //URLs
            tableView.deselectRow(at: indexPath, animated: true)
            if let urlString = tweet?.urls[indexPath.row].keyword,
                let url = URL(string: urlString) {
                UIApplication.shared.open(url)
            } else {
                fatalError()
            }
        }
    }
    
}
