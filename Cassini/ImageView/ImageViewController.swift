//
//  ImageViewController.swift
//  ImageView
//
//  Created by Dong, Vincent on 7/30/17.
//  Copyright © 2017 Dong, Vincent. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    private let imageView = UIImageView()



    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.addSubview(imageView)
        scrollView.maximumZoomScale = 2.0
        scrollView.minimumZoomScale = 0.03
    }

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    private func fetchImage() {
        if let url = imageURL {
            spinner?.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                if let contents = try? Data(contentsOf: url) {
                    if url == self?.imageURL { //CHECK: can put on the if let line above.
                        DispatchQueue.main.async {
                            self?.image = UIImage(data: contents)
                        }
                    }
                }
            }
        }
    }

    var imageURL: URL? {
        didSet {
            //CHECK: only when we are on screen , do we fetch.
            // fetchImage()
            image = nil
            if view.window != nil {
                fetchImage()
            }
        }
    }

    //CHECK: this is what I missed
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
    }

    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            scrollView?.contentOffset = imageView.frame.origin
            spinner?.stopAnimating()
        }
    }

}

extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
