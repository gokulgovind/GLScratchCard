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
    @IBOutlet weak var swipeBackToView:UIView!
    @IBOutlet weak var scratchContainerView:UIView!
    @IBOutlet weak var closeButton:UIButton!
    @IBOutlet weak var doneButton:UIButton!
    @IBOutlet weak var scratchCardTitleLabel:UILabel!
    @IBOutlet weak var scratchCardSubTitleLabel:UILabel!
    @IBOutlet weak public var scratchCardImageView:GLScratchCardImageView!
    
    // Delegate
    fileprivate var delegates = [GLScratchCardDelegate?]()
    internal var isScratchStarted = false
    //Var&Constants
    public var bottomLayerView:UIView? {
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
    
    public var topLayerImage:UIImage {
        get {
            let bundle = Bundle(for: GLScratchCardView.self)
            bundle.loadNibNamed("GLScratchCardView", owner:self, options:nil)
            if let imagePath = bundle.path(forResource: "scratch_image_new", ofType: "png") {
                let returnImage = UIImage(contentsOfFile: imagePath) ?? UIImage()
                scratchCardImageView.topLayerImageReference = returnImage
                return returnImage
            }
            return UIImage()
        }set{
            scratchCardImageView.image = newValue
            scratchCardImageView.topLayerImageReference = newValue
        }
    }
    public var afterScratchDoneButtonTitle = "Done"
    public var doneButtonTitle:String {
        get {
            return "Done"
        } set {
            doneButton.setTitle(newValue, for: .normal)
        }
    }
    public var afterScratchTitle = ""
    public var scratchCardTitle :String {
        get {
            return ""
        } set {
            scratchCardTitleLabel.text = newValue
        }
    }
    public var afterScratchSubTitle = ""
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
        
        scratchCardImageView.image = topLayerImage
        guard let content = scratchView else { return }
        content.frame = self.bounds
        self.addSubview(content)
    }
    
    fileprivate func setupUIComponents() {
        doneButton.setTitle(doneButtonTitle, for: .normal)
        scratchCardTitleLabel.text = scratchCardTitle
        scratchCardSubTitleLabel.text = scratchCardSubTitle
        scratchContainerView.bringSubview(toFront: scratchCardImageView)
        swipeBackToView.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            if !self.isScratchStarted {
                self.swipeBackToView.isHidden = false
                self.scratchContainerView.bringSubview(toFront: self.swipeBackToView)
            }
        }
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
