//
//  ViewController.swift
//  GLScratchCard
//
//  Created by gokulece26@gmail.com on 08/15/2019.
//  Copyright (c) 2019 gokulece26@gmail.com. All rights reserved.
//

import UIKit
import GLScratchCard

class ViewController: UIViewController  {
    func didCloseButtonPressed(sender: UIButton) {
        print("close button ViewController")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showDemo(_ sender: UIButton) {
        
        let controller = GLScratchCardController(title: "")
        controller.scratchCardView.addDelegate(delegate: self)
        controller.scratchCardView.doneButtonTitle = "Gift to a friend"
        controller.presentScratchController()

    }
}

extension ViewController: GLScratchCardDelegate {
    
}
