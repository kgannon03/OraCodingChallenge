//
//  LoaderView.swift
//  OraCodeChallenge
//
//  Created by Kevin Gannon on 2/2/17.
//  Copyright © 2017 Kevin Gannon. All rights reserved.
//

import UIKit
import UIKit

@IBDesignable
class LoaderView : UIView {
    
    @IBInspectable var animating: Bool = false {
        didSet {
            if window != nil { animating ? start() : stop() }
        }
    }

    override var layer: CAShapeLayer {
        get {
            return super.layer as! CAShapeLayer
        }
    }
    
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.fillColor = nil
        layer.strokeColor = UIColor.white.cgColor
        layer.lineWidth = 2
        setPath()
    }
    
    private func start() {
        transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        animate()
        isHidden = false
    }
    
    private func stop() {
        transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        isHidden = true
        layer.removeAllAnimations()
    }
    
    override func didMoveToWindow() {
        if window != nil {
            animating ? start() : stop()
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(didEnterForeground),
                name: .UIApplicationWillEnterForeground,
                object: nil)
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(didEnterBackground),
                name: .UIApplicationDidEnterBackground,
                object: nil)
        }
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        if newWindow == nil {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    func didEnterForeground() {
        if window != nil && animating { start() }
    }
    
    func didEnterBackground() {
        stop()
    }
    
    private func setPath() {
        layer.path = UIBezierPath(ovalIn: bounds
            .insetBy(dx: layer.lineWidth / 2, dy: layer.lineWidth / 2))
            .cgPath
    }
    
    private struct Pose {
        let secondsSincePriorPose: CFTimeInterval
        let start: CGFloat
        let length: CGFloat
        init(_ secondsSincePriorPose: CFTimeInterval, _ start: CGFloat, _ length: CGFloat) {
            self.secondsSincePriorPose = secondsSincePriorPose
            self.start = start
            self.length = length
        }
    }
    
    private class var poses: [Pose] {
        get {
            return [
                Pose(0.0, 0.000, 0.0),
                Pose(0.25, 0.250, 0.7),
                Pose(0.25, 0.500, 0.7),
                Pose(1.0, 1.500, 0.01),
                Pose(0.25, 1.750, 0.7),
                Pose(0.25, 2.000, 0.7),
                Pose(1.0, 3.00, 0.0)
            ]
        }
    }
    
    private func animate() {
        var time: CFTimeInterval = 0
        var times = [CFTimeInterval]()
        var start: CGFloat = 0
        var rotations = [CGFloat]()
        var strokeEnds = [CGFloat]()
        
        let poses = type(of: self).poses
        let totalSeconds = poses.reduce(0) { $0 + $1.secondsSincePriorPose }
        let originRotation = CGFloat(-M_PI_2)
        
        for pose in poses {
            time += pose.secondsSincePriorPose
            times.append(time / totalSeconds)
            start = pose.start
            rotations.append(originRotation + (start * 2 * CGFloat(M_PI)))
            strokeEnds.append(pose.length)
        }
        
        times.append(times.last!)
        rotations.append(rotations[0])
        strokeEnds.append(strokeEnds[0])
        
        animateKeyPath(keyPath: "strokeEnd", duration: totalSeconds, times: times, values: strokeEnds)
        animateKeyPath(keyPath: "transform.rotation", duration: totalSeconds, times: times, values: rotations)
    }
    
    private func animateKeyPath(keyPath: String, duration: CFTimeInterval, times: [CFTimeInterval], values: [CGFloat]) {
        let animation = CAKeyframeAnimation(keyPath: keyPath)
        animation.keyTimes = times as [NSNumber]?
        animation.values = values
        animation.calculationMode = kCAAnimationLinear
        animation.duration = duration
        animation.repeatCount = CFloat.infinity
        layer.add(animation, forKey: animation.keyPath)
    }
}

