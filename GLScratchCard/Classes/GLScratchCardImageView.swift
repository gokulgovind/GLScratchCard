//
//  GLScratchCardImageView.swift
//  GLScratchCard
//
//  Created by Payoda on 22/08/19.
//

import UIKit

public protocol GLScratchCarImageViewDelegate {
    func scratchpercentageDidChange(value: Float)
    func didScratchStarted()
    func didScratchEnded()
}
public class GLScratchCardImageView: UIImageView {
    private var lastPoint: CGPoint?
    
    public var lineType: CGLineCap = .round
    public var lineWidth: CGFloat = 30
    
    public var benchMarkScratchPercentage: Float = 40
    fileprivate var currentScratchPercentage: Float = 0
    internal var topLayerImageReference :UIImage?
    fileprivate var isScratchStarted = false
    fileprivate var isScratchEnded = false
    fileprivate var delegates = [GLScratchCarImageViewDelegate?]()
    fileprivate var timer:Timer?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        isUserInteractionEnabled = true
    }
    
    public func addDelegate(delegate: GLScratchCarImageViewDelegate?) {
        delegates.append(delegate)
    }
    
    @objc public func scratchAndShowBottomLayerView() {
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
    // Scratch
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard  let touch = touches.first else {
            return
        }
        lastPoint = touch.location(in: self)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.scratchAndShowBottomLayerView), userInfo: nil, repeats: true)
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
    
    private func alphaOnlyPersentage(img: UIImage) -> Float {
        
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
