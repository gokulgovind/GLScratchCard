//
//  GLScratchCardImageView.swift
//  GLScratchCard
//
//  Created by Payoda on 22/08/19.
//

import UIKit

public protocol GLScratchCarImageViewDelegate {
    func scratchpercentageDidChange(value: Int)
    func reachedDesiredScratchPercentage(percentage: Int, imageView: GLScratchCardImageView)
}
public class GLScratchCardImageView: UIImageView {
    private var lastPoint: CGPoint?
    
    public var lineType: CGLineCap = .round
    public var lineWidth: CGFloat = 30
    public var notifyOnReachingScratchPercentage: Int = 1
    
    fileprivate var delegates = [GLScratchCarImageViewDelegate?]()
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        isUserInteractionEnabled = true
    }
    
    public func addDelegate(delegate: GLScratchCarImageViewDelegate?) {
        delegates.append(delegate)
    }
    
    public func scratchAndShowValue() {
        self.image = nil
    }
    
    // Scratch
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard  let touch = touches.first else {
            return
        }
        lastPoint = touch.location(in: self)
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard  let touch = touches.first, let point = lastPoint, let img = image  else {
            return
        }
        
        let currentLocation = touch.location(in: self)
        eraseBetween(fromPoint: point, currentPoint: currentLocation)
        
        let progress = Int(round(alphaOnlyPersentage(img: img)) * 100)
        if progress == notifyOnReachingScratchPercentage {
            for delegate in delegates {
                delegate?.reachedDesiredScratchPercentage(percentage: notifyOnReachingScratchPercentage, imageView: self)
            }
        }
        for delegate in delegates {
            delegate?.scratchpercentageDidChange(value: progress)
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
