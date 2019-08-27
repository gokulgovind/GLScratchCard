//
//  GLScratchCardImageView.swift
//  GLScratchCard
//
//  Created by gokulece26@gmail.com on 22/08/19.
//

import UIKit

// MARK:- Delegate
/// **Delegate:** Helps to track scratch behaviour like,
/// Start, Stop and Progressive scratch percentage
public protocol GLScratchCarImageViewDelegate {
    /// **Delegate:** When user starts scratching, this delegate function will give scratch percentage
    ///
    /// - Parameter value: Scratch percentage 0 to 100
    func scratchpercentageDidChange(value: Float)
    /// **Delegate:** Intimates when scratch starts
    func didScratchStarted()
    /// **Delegate:** Intimates when scratch ends
    func didScratchEnded()
}
// MARK:-


/// GLScratchCardImageView is a sun class of UIImageview, Provides scratch effect over image view.
public class GLScratchCardImageView: UIImageView {
    // MARK: Public variables
    private var lastPoint: CGPoint?
    /// Type of scratch line, enum of **CGLineCap**. Default value is *.round*
    /// - .round
    /// - .square
    /// - .butt
    public var lineType: CGLineCap = .round
    /// Scratch line width, Default value is **30**
    public var lineWidth: CGFloat = 30
    
    /// Default value is **40**, **Important:** Setting 0 will disable this functionality.
    /// - If user scratched above this value and stay ideal for few seconds, Auto scratch will happen and reviles the bottom view
    /// - If user scratched below this value and stay ideal for few seconds, Scratched portion will be gone. User has to scratch again
    public var benchMarkScratchPercentage: Float = 40
    
    // MARK:- Internal Variables
    fileprivate var currentScratchPercentage: Float = 0
    internal var topLayerImageReference :UIImage?
    fileprivate var isScratchStarted = false
    fileprivate var isScratchEnded = false
    fileprivate var delegates = [GLScratchCarImageViewDelegate?]()
    fileprivate var timer:Timer?
    
    // MARK:-
    override public func awakeFromNib() {
        super.awakeFromNib()
        isUserInteractionEnabled = true
    }
    
    /// Helps in subscribing to *GLScratchCarImageViewDelegate*, from multiple places at same time
    ///
    /// - Parameter delegate: self
    public func addDelegate(delegate: GLScratchCarImageViewDelegate?) {
        delegates.append(delegate)
    }
    
    @objc fileprivate func scratchAndShowBottomLayerView() {
        if currentScratchPercentage >= benchMarkScratchPercentage {
            self.image = nil
            scratchEnded()
        }else{
            self.image = topLayerImageReference
        }
    }
    
    fileprivate func scratchEnded() {
        currentScratchPercentage = 100
        isScratchEnded = true
        for delegate in delegates {
            delegate?.didScratchEnded()
        }
    }
    // MARK:- Core scratch functionality
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard  let touch = touches.first else {
            return
        }
        lastPoint = touch.location(in: self)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if benchMarkScratchPercentage != 0 {
            if timer != nil {
                timer?.invalidate()
                timer = nil
            }
            timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.scratchAndShowBottomLayerView), userInfo: nil, repeats: true)
        }
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        
        if !isScratchStarted {
            isScratchStarted = true
            for delegate in delegates {
                delegate?.didScratchStarted()
            }
        }
        guard  let touch = touches.first, let point = lastPoint, let img = image  else {
            return
        }
        
        let currentLocation = touch.location(in: self)
        eraseBetween(fromPoint: point, currentPoint: currentLocation)
        
        currentScratchPercentage = alphaOnlyPersentage(img: img) * 100

        if currentScratchPercentage >= 100 && !isScratchEnded {
            scratchEnded()
        }
        for delegate in delegates {
            delegate?.scratchpercentageDidChange(value: currentScratchPercentage)
        }
        
        lastPoint = currentLocation
    }
    
    
    /// Creats scratch effect between two points
    ///
    /// - Parameters:
    ///   - fromPoint: Starting Point
    ///   - currentPoint: Ending Point
    fileprivate func eraseBetween(fromPoint: CGPoint, currentPoint: CGPoint) {
        
        UIGraphicsBeginImageContext(self.frame.size)
        
        image?.draw(in: self.bounds)
        
        let path = CGMutablePath()
        path.move(to: fromPoint)
        path.addLine(to: currentPoint)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setShouldAntialias(true)
        context.setLineCap(lineType)
        context.setLineWidth(lineWidth)
        context.setBlendMode(.clear)
        context.addPath(path)
        context.strokePath()
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
    }
    
    /// To get percentage of scratch effect applied
    ///
    /// - Parameter img: UIImage
    /// - Returns: Scratch percentage
    fileprivate func alphaOnlyPersentage(img: UIImage) -> Float {
        
        let width = Int(img.size.width)
        let height = Int(img.size.height)
        
        let bitmapBytesPerRow = width
        let bitmapByteCount = bitmapBytesPerRow * height
        
        let pixelData = UnsafeMutablePointer<UInt8>.allocate(capacity: bitmapByteCount)
        
        let colorSpace = CGColorSpaceCreateDeviceGray()
        
        let context = CGContext(data: pixelData,
                                width: width,
                                height: height,
                                bitsPerComponent: 8,
                                bytesPerRow: bitmapBytesPerRow,
                                space: colorSpace,
                                bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.alphaOnly.rawValue).rawValue)!
        
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        context.clear(rect)
        context.draw(img.cgImage!, in: rect)
        
        var alphaOnlyPixels = 0
        
        for x in 0...Int(width) {
            for y in 0...Int(height) {
                
                if pixelData[y * width + x] == 0 {
                    alphaOnlyPixels += 1
                }
            }
        }
        
        free(pixelData)
        
        return Float(alphaOnlyPixels) / Float(bitmapByteCount)
    }
}
