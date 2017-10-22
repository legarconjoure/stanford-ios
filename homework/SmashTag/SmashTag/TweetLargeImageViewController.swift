//
//  TweetLargeImageViewController.swift
//  SmashTag
//
//  Created by Dong, Vincent on 10/7/17.
//  Copyright © 2017 Dong, Vincent. All rights reserved.
//

import UIKit

//ASSIGNMENT 4 Task 7
//Don't quite understand the requirement of auto zooming to fit...
class TweetLargeImageViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    private let imageView = UIImageView()
    
    override func viewDidLoad() {
        scrollView.delegate = self
        scrollView.addSubview(imageView)
        scrollView.maximumZoomScale = 2.0
        scrollView.minimumZoomScale = 0.5
    }

    var image: UIImage? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        imageView.image = image
        imageView.sizeToFit()
        scrollView?.contentSize = imageView.frame.size
        scrollView?.contentOffset = imageView.frame.origin
    }
}

extension TweetLargeImageViewController {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
