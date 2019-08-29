//
//  GLScratchCardController.swift
//  GLScratchCard
//
//  Created by gokulece26@gmail.com on 17/08/19.
//

import UIKit

let application = UIApplication.shared
let keyWindow = UIApplication.shared.keyWindow

/// Main controller that contains Scratch UI
open class GLScratchCardController: NSObject {

    /// UIView loading UI components from XIB.
    lazy public var scratchCardView :GLScratchCardView = {
        let view = GLScratchCardView(frame: (application.keyWindow?.frame)!)
        view.addDelegate(delegate: self)
        view.scratchCardImageView.addDelegate(delegate: self)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        return view
    }()
    
    public init(title: String) {
        super.init()
    }
    
    /// Presents the *GLScratchCardController* 
    public func presentScratchController() {
        scratchCardView.translatesAutoresizingMaskIntoConstraints = false
        
        keyWindow?.addSubview(scratchCardView)
        keyWindow?.bringSubview(toFront: scratchCardView)
        
        var constraints = [NSLayoutConstraint]()
        
        let bannerHorizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|[scratchCardView]|", options: [], metrics: nil, views: ["scratchCardView":scratchCardView])
        constraints += bannerHorizontalConstraint
        let bannerVerticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|[scratchCardView]|", options: [], metrics: nil, views: ["scratchCardView":scratchCardView])
        constraints += bannerVerticalConstraint
        
        NSLayoutConstraint.activate(constraints)
    }
}

extension GLScratchCardController: GLScratchCardDelegate {
    public func didDoneButtonPressed(sender: UIButton) {
        
    }
    public func didCloseButtonPressed(sender: UIButton) {
        if let view = keyWindow?.subviews.filter({ (view) -> Bool in
            return view.isKind(of: GLScratchCardView.self)
        }), view.count > 0 {
            view[0].removeFromSuperview()
        }
        
    }
}

extension GLScratchCardController: GLScratchCarImageViewDelegate {
    
    public func scratchpercentageDidChange(value: Float) {
        print("Progress: \(value)")
    }

    public func didScratchStarted() {
        scratchCardView.swipeBackToView.isHidden = true
        scratchCardView.doneButton.isHidden = true
        scratchCardView.scratchCardTitleLabel.isHidden = true
        scratchCardView.scratchCardSubTitleLabel.isHidden = true
        scratchCardView.isScratchStarted = true
    }
    
    public func didScratchEnded() {
        scratchCardView.doneButton.isHidden = scratchCardView.afterScratchDoneButtonTitle == ""
        scratchCardView.scratchCardTitleLabel.isHidden = false
        scratchCardView.scratchCardSubTitleLabel.isHidden = false
        
        scratchCardView.doneButton.setTitle(scratchCardView.afterScratchDoneButtonTitle , for: .normal)
        
        scratchCardView.scratchCardTitleLabel.text = scratchCardView.afterScratchTitle
        scratchCardView.scratchCardSubTitleLabel.text = scratchCardView.afterScratchSubTitle
    }
    
}
