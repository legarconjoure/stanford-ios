//
//  TweetMentionsImageCellTableViewCell.swift
//  SmashTag
//
//  Created by Dong, Vincent on 10/7/17.
//  Copyright © 2017 Dong, Vincent. All rights reserved.
//

import UIKit
import Twitter

class TweetMentionsImageCellTableViewCell: UITableViewCell {

    @IBOutlet weak var mentionImageView: UIImageView!

    var mediaItem: Twitter.MediaItem? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        if let url = mediaItem?.url,
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data) {
            self.imageView?.image = image
        }
    }

}
