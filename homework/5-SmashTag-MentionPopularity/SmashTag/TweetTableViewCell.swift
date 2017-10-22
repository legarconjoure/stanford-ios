//
//  TweetTableViewCell.swift
//  SmashTag
//
//  Created by Dong, Vincent on 9/30/17.
//  Copyright © 2017 Dong, Vincent. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetProfileImageVIew: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetUserLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    var tweet: Twitter.Tweet? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        tweetTextLabel?.attributedText = attributedText(forTweet: tweet)
        tweetUserLabel?.text = tweet?.user.description
        
        if let profileImageURL = tweet?.user.profileImageURL {
            if let imageData = try? Data(contentsOf: profileImageURL) {
                tweetProfileImageVIew?.image = UIImage(data: imageData)
            }
        } else {
            tweetProfileImageVIew?.image = nil
        }
        
        if let created = tweet?.created {
            let formatter = DateFormatter()
            if Date().timeIntervalSince(created) > 24*60*60 {
                formatter.dateStyle = .short
            } else {
                formatter.timeStyle = .short
            }
            tweetCreatedLabel?.text = formatter.string(from: created)
        } else {
            tweetCreatedLabel?.text = nil
        }
    }
    
    // Assignment 4-1:
    // Enhance Smashtag from lecture to highlight (in a different color for each)
    // hashtags, urls and user screen names mentioned in the text of each Tweet (these are known as “mentions”).
    private func attributedText(forTweet tweet: Twitter.Tweet?) -> NSAttributedString? {
        if let tweet = tweet {
            let hashtags = tweet.hashtags
            let urls = tweet.urls
            let userMentions = tweet.userMentions
            
            let hashtagColor = UIColor.green
            let urlColor = UIColor.blue
            let userMentionColor = UIColor.cyan
            
            let attributedString = NSMutableAttributedString(string: tweet.text)
            
            for hashtag in hashtags {
                attributedString.addAttribute(
                    NSAttributedStringKey.foregroundColor,
                    value: hashtagColor,
                    range: hashtag.nsrange
                )
            }
            
            for url in urls {
                attributedString.addAttribute(
                    NSAttributedStringKey.foregroundColor,
                    value: urlColor,
                    range: url.nsrange
                )
            }
            
            for userMention in userMentions {
                attributedString.addAttribute(
                    NSAttributedStringKey.foregroundColor,
                    value: userMentionColor,
                    range: userMention.nsrange
                )
            }
            
            return attributedString
        }
        return nil
    }
}
