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
    @IBOutlet weak var demoOne: UIButton!
    @IBOutlet weak var demoTwo: UIButton!
    @IBOutlet weak var demoThree: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showGooglePayStyleDemo(_ sender: UIButton) {
        hideDemoButtons()
        
        let controller = GLScratchCardController()
        controller.scratchCardView.addDelegate(delegate: self)
        
        controller.scratchCardView.doneButtonTitle = "Gift to a friend"
        controller.scratchCardView.scratchCardTitle = "Earn up to ₹1,0000"
        controller.scratchCardView.scratchCardSubTitle = "From Google Pay \nEarned for paying \nGokul"
        
        controller.scratchCardView.afterScratchDoneButtonTitle = "Done"
        controller.scratchCardView.afterScratchTitle = "Woohoo!"
        controller.scratchCardView.afterScratchSubTitle = "Expect payment within a weak."
        
        controller.scratchCardView.bottomLayerView = UIImageView(image: UIImage(named: "cash_back"))
        controller.scratchCardView.topLayerImage = UIImage(named:"scratch_image")!
        
        controller.scratchCardView.scratchCardImageView.lineWidth = 50
        controller.scratchCardView.scratchCardImageView.lineType = .round
        
        controller.presentScratchController()

    }
    
    @IBAction func showPhonePayDemo(_ sender: UIButton) {
        hideDemoButtons()
        
        let controller = GLScratchCardController()
        controller.scratchCardView.addDelegate(delegate: self)
        
        controller.scratchCardView.bottomLayerView = UIImageView(image:  #imageLiteral(resourceName: "cash_back_phonepe.jpg"))
        controller.scratchCardView.topLayerImage = #imageLiteral(resourceName: "scratch_card_phonepe.jpg")
        
        controller.presentScratchController()
        
    }
    
    fileprivate func hideDemoButtons() {
        demoOne.isHidden = !demoOne.isHidden
        demoTwo.isHidden = !demoTwo.isHidden
        demoThree.isHidden = !demoThree.isHidden
    }
    /// Used Segu, Check Main.storyboard
//    @IBAction func showCustomScratchCardDemo(_ sender: UIButton) {
//
//    }
}

extension ViewController: GLScratchCardDelegate {
    func didDoneButtonPressed(sender: UIButton) {
        hideDemoButtons()
    }
    
    func didCloseButtonPressed(sender: UIButton) {
        hideDemoButtons()
    }
}

