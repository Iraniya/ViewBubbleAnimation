//
//  ChildViewController.swift
//  bubbleAnimation
//
//  Created by Iraniya Naynesh on 20/07/18.
//  Copyright © 2018 Iraniya. All rights reserved.
//

import UIKit

class ChildViewController: UIViewController {

    
    var parentVC: ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configGesture()
    }

    //MARK: PanGesture Init
    var dragDownPanGesture: UIPanGestureRecognizer!
    func configGesture() {
        tempFrame = self.view.frame
        dragDownPanGesture = UIPanGestureRecognizer(target: self, action: #selector(pangestureStartsDraging(withPanGesture:)))
        dragDownPanGesture.delegate = self
        self.view.addGestureRecognizer(dragDownPanGesture)
    }
    
    var tempFrame: CGRect!
}

extension ChildViewController: UIGestureRecognizerDelegate {
    
    //So that TV remote and menu gesture also work
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let panGesture : UIPanGestureRecognizer = gestureRecognizer as! UIPanGestureRecognizer
        let velocity: CGPoint = panGesture.velocity(in: self.view)
        return (fabs(velocity.y) > fabs(velocity.x))
    }
    
    @objc func pangestureStartsDraging(withPanGesture sender: UIPanGestureRecognizer) {

        let percentThreshold:CGFloat = 0.4
        let translation = sender.translation(in: view)
        let newY = ensureRange(value: self.tempFrame.minY + translation.y, minimum: 0, maximum: self.tempFrame.maxY)
        let progress = progressAlongAxis(newY, view.bounds.height)
        
        self.tempFrame.origin.y = newY
        let center = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height)
        let radius = self.view.bounds.height - newY
        let markPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(180).degreesToRadians, endAngle: CGFloat(360).degreesToRadians, clockwise: true)
        let shape = CAShapeLayer()
        shape.path = markPath.cgPath
        self.view.layer.mask = shape
        
        if sender.state == .ended || sender.state == .cancelled {
            if radius < self.view.bounds.width/2  || progress > percentThreshold {
                UIView.transition(with: self.view, duration: 0.35, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.parentVC?.removeChildViewController()
                }) { (finish) in

                }

            } else {
                UIView.transition(with: self.view, duration: 0.35, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    print("Restore to orignal position")
                    self.tempFrame.origin.y = 0
                    self.view.layer.mask = nil
                }) { (finish) in
                }
            }
        }
        sender.setTranslation(.zero, in: self.view)
    }

    private func ensureRange<T>(value: T, minimum: T, maximum: T) -> T where T : Comparable {
        return min(max(value, minimum), maximum)
    }

    private func progressAlongAxis(_ pointOnAxis: CGFloat, _ axisLength: CGFloat) -> CGFloat {
        let movementOnAxis = pointOnAxis / axisLength
        let positiveMovementOnAxis = fmaxf(Float(movementOnAxis), 0.0)
        let positiveMovementOnAxisPercent = fminf(positiveMovementOnAxis, 1.0)
        return CGFloat(positiveMovementOnAxisPercent)
    }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
