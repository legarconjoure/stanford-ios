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
        DispatchQueue.global().async { [weak self] in
            if let url = self?.imageURL,
                let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self?.image = image
                }
            }
        }
    }
    
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
        }
    }
    
    //STEP 4: add image view to view hierarchy
    override func viewDidLoad() {
        super.viewDidLoad()
        imageURL = DemoURL.stanford
    }
    
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
