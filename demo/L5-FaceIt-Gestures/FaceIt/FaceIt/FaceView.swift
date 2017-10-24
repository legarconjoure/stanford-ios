//
//  FaceView.swift
//  FaceIt
//
//  Created by Dong, Vincent on 9/6/17.
//  Copyright © 2017 ecg mobile. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {
    
    // Step 6 Fix: scale the face has to the super view
    @IBInspectable
    var scale: CGFloat = 0.9 { didSet { setNeedsDisplay() } /* redraw on any change */ }
    
    // Step 15: set eye to be closable
    @IBInspectable
    var eyesOpen: Bool = true { didSet { setNeedsDisplay() } /* redraw on any change */ }
    
    // Step 18: Mouth curvature
    @IBInspectable
    var mouthCurvature: Double = -0.5  { didSet { setNeedsDisplay() } /* redraw on any change */ } // 1.0 full smile, -1.0 full frown
    
    @IBInspectable
    var lineWidth: CGFloat = 5.0  { didSet { setNeedsDisplay() } /* redraw on any change */ }
    
    @IBInspectable
    var color: UIColor = .blue  { didSet { setNeedsDisplay() } /* redraw on any change */ }
    
    // L05 Step 7: Add Gesture Pinch: because it does not need the model we can put it in a view
    @objc func changeScale(byReactingTo pinchReconizer: UIPinchGestureRecognizer) {
        switch pinchReconizer.state {
        case .changed,.ended:
            scale *= pinchReconizer.scale
            // reset to one to allow for incremental scale,
            // otherwise if first time scale is 2.1, the next time 2.0 it would actually be 4.2.
            pinchReconizer.scale = 1
        default:
            break //everything else doesn't matter
        }
    }
    
    // Step 9: Move those skull values to be private vars
    // Step 1: To make the face always fit no matter in landscape or portrait
    private var skullRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    
    // Step 2: Center the skull
    // cannot use let skullCenter = center.
    // why?
    // my answer: center is the center of FaceView as a parent, but we want the center of its parent
    // so it should be superview.center
    // professor's answer: this center is in the superview's coordinate system
    // I am in draw, so I need it to be in my own coordinate system
    
    // solution 1: use convert function to convert from one system to another
    // let skullCenter = convert(center, from: superview)
    
    // solution 2: just use a CGPoint
    private var skullCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    // Step 8: Now I want some internal architecture
    // some functions for paths for skull, eyes, mouth.
    private func pathForSkull() -> UIBezierPath {
        // Step 3: Now draw a circle
        let path = UIBezierPath(arcCenter: skullCenter,
                                radius: skullRadius,
                                startAngle: 0,
                                endAngle: 2 * CGFloat.pi, //MUST: use CGFloat instead of a Double.pi.
            clockwise: false)
        
        // Step 4: Set some attributes for the path
        path.lineWidth = lineWidth
        return path
    }
    
    // Step 10: Path for eyes
    private enum Eye {
        case left
        case right
    }
    
    private func pathForEye(_ eye: Eye) -> UIBezierPath {
        // Step 12: Create a function for center of eye
        // As it's only used in path for eye, it makes sense to use an internal function
        func centerOfEye(_ eye: Eye) -> CGPoint {
            let eyeOffset = skullRadius / Ratios.skullRadiusToEyeOffset
            var eyeCenter = skullCenter
            eyeCenter.y -= eyeOffset
            eyeCenter.x += ((eye == .left) ? -1 : 1) * eyeOffset
            return eyeCenter
        }
        
        let eyeRadius = skullRadius / Ratios.skullRadiusToEyeRadius
        let eyeCenter = centerOfEye(eye)
        
        let path: UIBezierPath
        
        if eyesOpen {
            path = UIBezierPath(arcCenter: eyeCenter,
                                radius: eyeRadius,
                                startAngle: 0,
                                endAngle: 2 * CGFloat.pi,
                                clockwise: false)
        } else {
            path = UIBezierPath()
            path.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
            path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
        }
        path.lineWidth = lineWidth
        return path
    }
    
    // Step 16: Path for mouth
    private func pathForMouth() -> UIBezierPath {
        // First calculate mouth arguments
        let mouthWidth = skullRadius / Ratios.skullRadiusToMouthWidth
        let mouthHeight = skullRadius / Ratios.skullRadiusToMouthHeight
        let mouthOffset = skullRadius / Ratios.skullRadiusToMouthOffset
        
        let mouthRect = CGRect(
            x: skullCenter.x - mouthWidth / 2,
            y: skullCenter.y + mouthOffset,
            width: mouthWidth,
            height: mouthHeight
        )
        
        // Step 18: curvature
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.midY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.midY)
        
        // Control points
        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height
        let cp1 = CGPoint(x: start.x + mouthWidth / 3, y: start.y + smileOffset)
        let cp2 = CGPoint(x: end.x - mouthWidth / 3, y: start.y + smileOffset)
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        
        path.lineWidth = lineWidth

        return path
    }

    override func draw(_ rect: CGRect) {
        color.set()

        // Step 5: Stroke!
        pathForSkull().stroke()
        
        // Step 6: Run it!
        // And... see the face go all the width to the edges, not good, lets fix it.
        
        // Step 7: Rotate!
        // It becomes an oval! Let's fix it.
        // use "Redraw" in the inspector
        
        // Step 13: Stroke more
        pathForEye(.left).stroke()
        pathForEye(.right).stroke()
        pathForMouth().stroke()
    }
    
    // Step 11: Some relative arguments
    // This is how we do constants in Swift
    // Nice things using struct here:
    // 1. It groups them togethers
    // 2. It types them
    private struct Ratios {
        static let skullRadiusToEyeOffset: CGFloat = 3
        static let skullRadiusToEyeRadius: CGFloat = 10
        static let skullRadiusToMouthWidth: CGFloat = 1
        static let skullRadiusToMouthHeight: CGFloat = 3
        static let skullRadiusToMouthOffset: CGFloat = 3
    }

}
