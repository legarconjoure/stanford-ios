//
//  EmotionsViewController.swift
//  FaceIt
//
//  Created by Dong, Vincent on 9/8/17.
//  Copyright © 2017 ecg mobile. All rights reserved.
//

import UIKit

class EmotionsViewController: VCLLoggingViewController {

    // MARK: - Navigation

    // L06 Step 2: Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // L06 Step 4: Get destination content controller
        if let faceViewController = segue.destination.contents as? FaceViewController {
            assert(segue.identifier != nil)
            faceViewController.expression = emotions[segue.identifier!] ?? FacialExpression(eyes: .open, mouth: .smile)
            faceViewController.navigationItem.title = (sender as? UIButton)?.currentTitle
        }
    }
    
    private let emotions = [
        "sad": FacialExpression(eyes: .closed, mouth: .frown),
        "happy": FacialExpression(eyes: .open, mouth: .smile),
        "worried": FacialExpression(eyes: .open, mouth: .smirk)
    ]
    
    // L06 Step 3: Add navigation controller to support iPhone

}

// L06 Step 4: Get destination controller
extension UIViewController {
    var contents: UIViewController {
        get {
            if let navigationViewController = self as? UINavigationController {
                return navigationViewController.visibleViewController ?? self
            } else {
                return self
            }
        }
    }
}

