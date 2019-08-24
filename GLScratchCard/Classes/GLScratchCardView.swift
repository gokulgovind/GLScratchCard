//
//  GLScratchCardView.swift
//  GLScratchCard
//
//  Created by Payoda on 17/08/19.
//

import UIKit

public protocol GLScratchCardDelegate {
    func didCloseButtonPressed(sender: UIButton)
    func didDoneButtonPressed(sender: UIButton)
}

public class GLScratchCardView: UIView {
    // UIComponents
    @IBOutlet weak var scratchView:UIView!
    @IBOutlet weak var scratchContainerView:UIView!
    @IBOutlet weak var closeButton:UIButton!
    @IBOutlet weak var doneButton:UIButton!
    @IBOutlet weak var scratchCardTitleLabel:UILabel!
    @IBOutlet weak var scratchCardSubTitleLabel:UILabel!
    @IBOutlet weak public var scratchCardImageView:GLScratchCardImageView!
    
    // Delegate
    fileprivate var delegates = [GLScratchCardDelegate?]()
    
    //Var&Constants
    public var scratchCardHiddenView:UIView? {
        get {
            return nil
        }set{
            if let bgView = newValue {
                scratchContainerView.addSubview(bgView)
                scratchContainerView.bringSubview(toFront: scratchCardImageView)
                
                bgView.translatesAutoresizingMaskIntoConstraints = false
                var constraints = [NSLayoutConstraint]()
                let bannerHorizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|[bgView]|", options: [], metrics: nil, views: ["bgView":bgView])
                constraints += bannerHorizontalConstraint
                let bannerVerticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|[bgView]|", options: [], metrics: nil, views: ["bgView":bgView])
                constraints += bannerVerticalConstraint
                
                NSLayoutConstraint.activate(constraints)
            }
        }
    }
    public var doneButtonTitle:String {
        get {
            return "Done"
        } set {
            doneButton.setTitle(newValue, for: .normal)
        }
    }
    public var scratchCardTitle :String {
        get {
            return ""
        } set {
            scratchCardTitleLabel.text = newValue
        }
    }
    public var scratchCardSubTitle :String {
        get {
            return ""
        } set {
            scratchCardSubTitleLabel.text = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        setupUIComponents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func loadViewFromNib() {
        let bundle = Bundle(for: GLScratchCardView.self)
        bundle.loadNibNamed("GLScratchCardView", owner:self, options:nil)
        if let imagePath = bundle.path(forResource: "scratch_image", ofType: "png") {
            scratchCardImageView.image = UIImage(contentsOfFile: imagePath)
        }
        guard let content = scratchView else { return }
        content.frame = self.bounds
        self.addSubview(content)
    }
    
    fileprivate func setupUIComponents() {
        doneButton.setTitle(doneButtonTitle, for: .normal)
        scratchCardTitleLabel.text = scratchCardTitle
        scratchCardSubTitleLabel.text = scratchCardSubTitle
        scratchContainerView.bringSubview(toFront: scratchCardImageView)
    }
    
    public func addDelegate(delegate: GLScratchCardDelegate?) {
        delegates.append(delegate)
    }
    
    //MARK: IBAction
    @IBAction func closeButtonAction(_ sender: UIButton) {
        for delegate in delegates {
            delegate?.didCloseButtonPressed(sender: sender)
        }
    }
    
    @IBAction func doneButtonAction(_ sender: UIButton) {
        for delegate in delegates {
            delegate?.didDoneButtonPressed(sender: sender)
        }
    }
    
}
