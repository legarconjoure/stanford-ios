//
//  ImageViewController.swift
//  Cassini
//
//  Created by Dong, Vincent on 10/14/17.
//  Copyright © 2017 Dong, Vincent. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    //STEP 1: Model
    var imageURL: URL? {
        //STEP 5: when setting image url, clear away the image and fetch the image in the new URL
        didSet {
            //clean
            image = nil
            if view.window != nil { //if on screen
                fetchImage()
            }
        }
    }
    
    private func fetchImage() {
        if let url = imageURL {
            spinner.startAnimating()
            DispatchQueue.global().async { [weak self] in
                let urlContents = try? Data(contentsOf: url)
                if let imageData = urlContents, url == self?.imageURL {
                    DispatchQueue.main.async {
                        self?.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.5
            scrollView.maximumZoomScale = 2.0
            //IMPORTANT: content size!
            scrollView.contentSize = imageView.frame.size
            scrollView.addSubview(imageView)
        }
    }
    //STEP 2: Need an image view. Without arguments means it's at CGPoint(0, 0)
    private var imageView = UIImageView()
    
    //STEP 3: code organization thing. Don't have to call these over and over.
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size // <-- this is very bad if non-optional, so optional for possible segue
            spinner?.stopAnimating() //put here to be more general: not only when image is fetched (like maybe some local URL is set)
        }
    }
    
    //STEP 4: add image view to view hierarchy
    //L8 STEP1: Delete this to make this reusable again
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        imageURL = DemoURL.stanford
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
    }
}

extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
