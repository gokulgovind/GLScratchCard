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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showGooglePayStyleDemo(_ sender: UIButton) {
        let view = UIImageView()
        view.image = UIImage(named: "cash_back")
        
        let controller = GLScratchCardController(title: "")
        controller.scratchCardView.addDelegate(delegate: self)
        controller.scratchCardView.doneButtonTitle = "Gift to a friend"
        controller.scratchCardView.scratchCardTitle = "Earn up to ₹1,0000"
        controller.scratchCardView.scratchCardSubTitle = "From Google Pay \nEarned for paying \nGokul"
        
        controller.scratchCardView.afterScratchDoneButtonTitle = "Done"
        controller.scratchCardView.afterScratchTitle = "Woohoo!"
        controller.scratchCardView.afterScratchSubTitle = "Expect payment within a weak."
        
        controller.scratchCardView.bottomLayerView = view
        controller.scratchCardView.topLayerImage = UIImage(named:"scratch_image")!
        controller.scratchCardView.scratchCardImageView.lineWidth = 50
        controller.presentScratchController()

    }
    
    @IBAction func showPhonePayDemo(_ sender: UIButton) {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "cash_back_phonepe.jpg")
        
        let controller = GLScratchCardController(title: "")
        controller.scratchCardView.addDelegate(delegate: self)
        
        controller.scratchCardView.bottomLayerView = view
        controller.scratchCardView.topLayerImage = #imageLiteral(resourceName: "scratch_card_phonepe.jpg")
        controller.scratchCardView.scratchCardImageView.lineWidth = 50
        controller.presentScratchController()
        
    }
    
    @IBAction func showCustomScratchCardDemo(_ sender: UIButton) {
        
    }
}

extension ViewController: GLScratchCardDelegate {
    func didDoneButtonPressed(sender: UIButton) {
        print("Done button ViewController")
    }
    
    func didCloseButtonPressed(sender: UIButton) {
        print("close button ViewController")
    }
}

