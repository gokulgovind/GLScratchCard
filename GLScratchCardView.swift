//
//  GLScratchCardView.swift
//  GLScratchCard
//
//  Created by Payoda on 17/08/19.
//

import UIKit

public protocol GLScratchCardDelegate {
    func didCloseButtonPressed(sender: UIButton)
}

public class GLScratchCardView: UIView {
    // UIComponents
    var scratchView:UIView!
    let closeButton = UIButton()
    
    // Delegate
    fileprivate var delegates = [GLScratchCardDelegate?]()
    
    //Var&Constants
    public var doneButtonTitle = "Done"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupUI() {
        let marginGuide = self.layoutMarginsGuide
        func setupCloseButton() {
            let closeButton = UIButton()
            closeButton.translatesAutoresizingMaskIntoConstraints = false
            closeButton.backgroundColor = .green
            closeButton.addTarget(self, action: #selector(closeButtonAction(_:)), for: .touchUpInside)
            self.addSubview(closeButton)
 
            if #available(iOS 11.0, *) {
                closeButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
                closeButton.widthAnchor.constraint(equalToConstant: closeButtonSize).isActive = true
                closeButton.heightAnchor.constraint(equalToConstant: closeButtonSize).isActive = true
                closeButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive  = true
            } else {

            }
        }
        
        func setupDoneButton() {
            let doneButton = UIButton()
            doneButton.translatesAutoresizingMaskIntoConstraints = false
            doneButton.layer.cornerRadius = 20
            doneButton.backgroundColor = .red
            doneButton.setTitle(doneButtonTitle, for: .normal)
            doneButton.addTarget(self, action: #selector(doneButtonAction(_:)), for: .touchUpInside)
            self.addSubview(doneButton)
            if #available(iOS 11.0, *) {
                doneButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
                doneButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            }
            let leadingTrailingAndHeightConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[doneButton]-15-|", options: [], metrics: nil, views: ["doneButton":doneButton])
            
            NSLayoutConstraint.activate(leadingTrailingAndHeightConstraint)
            
        }
        
        setupCloseButton()
        setupDoneButton()
    }
    
    public func addDelegate(delegate: GLScratchCardDelegate?) {
        delegates.append(delegate)
    }
    
    //MARK: IBAction
    @objc func closeButtonAction(_ sender: UIButton) {
        for delegate in delegates {
            delegate?.didCloseButtonPressed(sender: sender)
        }
    }
    
    @objc func doneButtonAction(_ sender: UIButton) {
        for delegate in delegates {
            delegate?.didCloseButtonPressed(sender: sender)
        }
    }

}
