//
//  ViewController.swift
//  bubbleAnimation
//
//  Created by Iraniya Naynesh on 20/07/18.
//  Copyright © 2018 Iraniya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    var childViewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func addViewControllerButtonPressed(_ sender: UIButton!) {
        addChildViewController()
    }
    
    func addChildViewController() {
        removeChildViewController()
        childViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChildViewController") as! ChildViewController
        
        childViewController.view.frame = self.view.bounds
        self.view.addSubview(childViewController.view)
        childViewController.willMove(toParentViewController: self)
        
        //Bottom up transition animation
        childViewController.view.frame.origin.y = self.view.bounds.height
        UIView.transition(with: childViewController.view, duration: 0.35, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.childViewController.view.frame.origin.y = 0
        }) { (finish) in
            //do Things after after animation finish
        }
    }
    
    func removeChildViewController() {
        if childViewController != nil {
            childViewController.view.removeFromSuperview()
            childViewController.removeFromParentViewController()
            childViewController.willMove(toParentViewController: nil)
            childViewController = nil
        }
    }

}

