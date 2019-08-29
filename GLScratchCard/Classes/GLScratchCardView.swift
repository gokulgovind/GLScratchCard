//
//  GLScratchCardView.swift
//  GLScratchCard
//
//  Created by gokulece26@gmail.com on 17/08/19.
//

import UIKit

// MARK: - Delegate
/// **Delegate:** Notifies when UIButton action happens
/// - When close button pressed
/// - When Done button pressed
public protocol GLScratchCardDelegate {
    func didCloseButtonPressed(sender: UIButton)
    func didDoneButtonPressed(sender: UIButton)
}

public class GLScratchCardView: UIView {
    // MARK: - IBOutlets
    @IBOutlet weak var scratchView:UIView!
    @IBOutlet weak var swipeBackToView:UIView!
    @IBOutlet weak var scratchContainerView:UIView!
    @IBOutlet weak var closeButton:UIButton!
    @IBOutlet weak var doneButton:UIButton!
    @IBOutlet weak var scratchCardTitleLabel:UILabel!
    @IBOutlet weak var scratchCardSubTitleLabel:UILabel!
    @IBOutlet weak public var scratchCardImageView:GLScratchCardImageView!
    
    // MARK: - Internal Variables
    fileprivate var delegates = [GLScratchCardDelegate?]()
    internal var isScratchStarted = false
    fileprivate var doneButtonHeight:CGFloat = 0
    // MARK: - Public Variables
    /// UIView that will be the *bottom layer* of scratch controller
    /// (i.e) **Will displayed when scratch happens on top layer**
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
    
    /// UIImage that will be the *top layer* of scratch controller
    /// Scratch effect will be applied to this image
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
    
    /// Done button can have two titles
    /// * One before scratch starts
    /// * One after scratch ends
    /// If empty Done button will be hidden
    public var afterScratchDoneButtonTitle = ""
    
    /// Done button can have two titles
    /// * One before scratch starts
    /// * One after scratch ends
    /// If empty Done button will be hidden
    public var doneButtonTitle:String {
        get {
            return ""
        } set {
            doneButton.isHidden = newValue == ""
            doneButton.setTitle(newValue, for: .normal)
        }
    }
    
    /// Title label can have two titles
    /// * One before scratch starts
    /// * One after scratch ends
    public var afterScratchTitle = ""
    
    /// Title label can have two titles
    /// * One before scratch starts
    /// * One after scratch ends
    public var scratchCardTitle :String {
        get {
            return ""
        } set {
            scratchCardTitleLabel.text = newValue
        }
    }
    
    /// Sub Title label can have two titles
    /// * One before scratch starts
    /// * One after scratch ends
    public var afterScratchSubTitle = ""
    
    /// Sub Title label can have two titles
    /// * One before scratch starts
    /// * One after scratch ends
    public var scratchCardSubTitle :String {
        get {
            return ""
        } set {
            scratchCardSubTitleLabel.text = newValue
        }
    }
    
    // MARK: - Init
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
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if doneButton != nil {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.scratchView.layoutIfNeeded()
                self.doneButton.layer.cornerRadius = self.doneButton.bounds.height / 2
            }
            
        }
    }
    
    
    fileprivate func setupUIComponents() {
        doneButton.setTitle(doneButtonTitle, for: .normal)
        doneButton.isHidden = doneButtonTitle == ""
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
    
    /// Helps in subscribing to *GLScratchCardDelegate*, from multiple places at same time
    ///
    /// - Parameter delegate: self
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
