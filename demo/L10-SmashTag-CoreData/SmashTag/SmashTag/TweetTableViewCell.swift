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
        tweetTextLabel?.text = tweet?.text
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
}
