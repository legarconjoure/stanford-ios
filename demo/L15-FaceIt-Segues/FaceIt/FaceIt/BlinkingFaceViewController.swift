//
//  BlinkingFaceViewController.swift
//  FaceIt
//
//  Created by Dong, Vincent on 9/11/17.
//  Copyright © 2017 ecg mobile. All rights reserved.
//

import UIKit

// L13 Step 01: Create a new BlinkFaceViewController
// Change the storyboard to this view controller
class BlinkingFaceViewController: FaceViewController {
    var blinking = false {
        didSet {
            blinkIfNeeded()
        }
    }
    
    override func updateUI() {
        super.updateUI()
        blinking = expression.eyes == .squinting
    }
    
    private var canBlink = false
    private var inABlink = false
    
    // how long closed, how long open
    private struct BlinkRate {
        static let closedDuration: TimeInterval = 0.4
        static let openDuration: TimeInterval = 2.5
    }
    
    private func blinkIfNeeded() {
        if blinking && canBlink && !inABlink {
            faceView.eyesOpen = false
            inABlink = true
            Timer.scheduledTimer(withTimeInterval: BlinkRate.closedDuration, repeats: false) { [weak self] timer in
                self?.faceView.eyesOpen = true
                Timer.scheduledTimer(withTimeInterval: BlinkRate.openDuration, repeats: false) { [weak self] timer in
                    self?.inABlink = false
                    self?.blinkIfNeeded()
                }
            }
        }
    }
    
    // want this to start timer only when on screen
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        canBlink = true
        blinkIfNeeded()
    }

    // and make sure to stop timer when off screen
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        canBlink = false
    }
}
