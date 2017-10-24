//
//  ViewController.swift
//  FaceIt
//
//  Created by Dong, Vincent on 9/6/17.
//  Copyright © 2017 ecg mobile. All rights reserved.
//

import UIKit

// L06 Step 1: Change ViewController name to something more specific
class FaceViewController: VCLLoggingViewController {
    // Step 1. Create an outlet for the view
    @IBOutlet weak var faceView: FaceView!
    // Step 6: Another place to update UI is here
    // It's less obvious but needed. Why?
    // My answer: when the outlet is first being set we need to make sure the UI matches the model
    // Professor's answer:
    // Reason 1: in the short amount of time when the outlet is not hooked by iOS yet, what if the model gets set?
    // then updateUI is not going to work because faceView hasn't been connected yet
    // My understanding of professor's talk: So after it's connected, make sure the UI is updated to match model.
    // Reason 2: expression 's didSet will not be called when it's being initialized (only called when it's set)
    // Another problem is that what if expression gets set before the faceView is hooked? updateUI() is going to crash because faceView is nil.
    // Solution: Use optional chaining in the updateUI for faceView.
    // This is often something you want to do in your updateUI thing: Protecting against your outlets not being set.
    {
        didSet {
            // L05 Step 8: Add a pinch gesture handler right after hook up
            let handler = #selector(FaceView.changeScale(byReactingTo:))
            let pinchRecognizer = UIPinchGestureRecognizer(target: faceView, action: handler)
            faceView.addGestureRecognizer(pinchRecognizer)
            // L05 Step 10: Add tap gesture to toggle eyes
//            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleEyes(byReactingTo:)))
//            // not needed below: default
//            //tapRecognizer.numberOfTapsRequired = 1
//            faceView.addGestureRecognizer(tapRecognizer)
            
            let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(happierFace))
            swipeUp.direction = .up
            faceView.addGestureRecognizer(swipeUp)
            
            let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(sadderFace))
            swipeDown.direction = .down
            faceView.addGestureRecognizer(swipeDown)

            updateUI()
        }
    }
    
    // L05 Step 9: Add a gesture func to handle tap to toggle eye
    @objc func toggleEyes(byReactingTo tapRecognizer: UITapGestureRecognizer) {
        if tapRecognizer.state == .ended {
            let eyes: FacialExpression.Eyes = (expression.eyes == .closed) ? .open : .closed
            // !! Now set the model to a new facial expression
            // And the didSet will be called to update the view.
            // So there's no need to call it explicitly here again.
            expression = FacialExpression(eyes: eyes, mouth: expression.mouth)
        }
    }
    
    // For swipe gestures we actully never need the argument
    // Because when it happens it happens...
    // So change below commented out to be...
//    @objc func happierFace(byReactingTo swipeUp: UISwipeGestureRecognizer) {
//        if swipeUp.state == .ended {
//            expression = expression.happier
//        }
//    }
//
//    @objc func sadderFace(byReactingTo swipeDown: UISwipeGestureRecognizer) {
//        if swipeDown.state == .ended {
//            expression = expression.sadder
//        }
//    }
    
    private struct HeadShake {
        static let angle = CGFloat.pi / 6
        static let segmentDuration: TimeInterval = 0.5
    }
    
    private func rotateFace(by angle: CGFloat) {
        faceView.transform = faceView.transform.rotated(by: angle)
    }
    
    private func shakeHead() {
        UIView.animate(
            withDuration: HeadShake.segmentDuration,
            animations: { self.rotateFace(by: HeadShake.angle) }, //don't need memory breakage here because we are in the middle of
                                                                  //an animation and the view controller is on the screen (thus in heap)
            completion: { finished in
                if finished {
                    UIView.animate(
                        withDuration: HeadShake.segmentDuration,
                        animations: { self.rotateFace(by: -HeadShake.angle * 2) },
                        completion: { finished in
                            if finished {
                                UIView.animate(withDuration: HeadShake.segmentDuration,
                                               animations: { self.rotateFace(by: HeadShake.angle) })
                            }
                    })
                }
            }
        )
    }
    
    @IBAction func shakeHead(_ sender: Any) {
        shakeHead()
    }

    @objc func happierFace() {
        expression = expression.happier
    }
    
    @objc func sadderFace() {
        expression = expression.sadder
    }
    
    
    // Step 2: Drag a FaceExpression.Swift as the model into the project
    
    // Step 3: A starting facial expression
    var expression = FacialExpression(eyes: .closed, mouth: .frown)
    // Step 6: If any time someone changes my expression, I want to update my UI
    // So it's a good thing to use the didSet for the var here to accomplish that.
    {
        didSet {
            updateUI()
        }
    }
    
    // Step 4: primary job of a controller is to interpret the model with the view
    // So create a private func here to make the model match the UI (maybe he should've said make the UI match the model??)
    private func updateUI() {
        switch expression.eyes {
        case .open:
            // Step 6: Use optional chaining to avoid crashing
            // When expression happens to be set before faceView is set, do nothing here.
            faceView?.eyesOpen = true
        case .closed:
            faceView?.eyesOpen = false
        case .squinting: // no way in the view to represent this, so just do the best we can here.
            faceView?.eyesOpen = false
        }
        
        // Step 5: As for the mouth, could have done with a switch...case, but it's messy
        // So see below for a data structure
        faceView?.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
    }
    
    // Step 5:
    private let mouthCurvatures = [
        FacialExpression.Mouth.grin: 0.5,
        .frown: -1.0,
        .smile: 1.0,
        .neutral: 0,
        .smirk: -0.5
    ]
}

