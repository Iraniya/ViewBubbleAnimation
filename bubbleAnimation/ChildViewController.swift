//
//  ChildViewController.swift
//  bubbleAnimation
//
//  Created by Iraniya Naynesh on 20/07/18.
//  Copyright © 2018 Iraniya. All rights reserved.
//

import UIKit

class ChildViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configGesture()
    }

    //MARK: PanGesture Init
    var dragDownPanGesture: UIPanGestureRecognizer!
    func configGesture() {
        dragDownPanGesture = UIPanGestureRecognizer(target: self, action: #selector(pangestureStartsDraging(withPanGesture:)))
        dragDownPanGesture.delegate = self
        self.view.addGestureRecognizer(dragDownPanGesture)
    }
    
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
        let newY = ensureRange(value: self.view.frame.minY + translation.y, minimum: 0, maximum: self.view.frame.maxY)
        let progress = progressAlongAxis(newY, view.bounds.height)
        self.view.frame.origin.y = newY //Move view to new position
        
        if sender.state == .ended || sender.state == .cancelled {
            let velocity = sender.velocity(in: view)
            if velocity.y >= self.view.frame.size.height || progress > percentThreshold {
                UIView.transition(with: self.view, duration: 0.35, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.view.frame.origin.y = self.view.frame.height
                }) { (finish) in
                    
                }
                
            } else {
                UIView.transition(with: self.view, duration: 0.35, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.view.frame.origin.y = 0
                    self.view.layoutIfNeeded()
                }) { (finish) in
                    self.view.layoutIfNeeded()
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
