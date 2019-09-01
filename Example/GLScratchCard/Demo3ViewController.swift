//
//  Demo3ViewController.swift
//  GLScratchCard_Example
//
//  Created by gokulece26@gmail.com on 01/09/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import GLScratchCard

class Demo3ViewController: UIViewController {

    @IBOutlet weak var scratchCardImageView:GLScratchCardImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scratchCardImageView.lineType = .square
        scratchCardImageView.lineWidth = 20
        scratchCardImageView.benchMarkScratchPercentage = 70
    }
    
    @IBAction func closeDemo3(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
