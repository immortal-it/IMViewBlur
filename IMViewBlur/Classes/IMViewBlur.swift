//
//  IMViewBlur.swift
//  IMViewBlur
//
//  Created by xys on 2021/3/26.
//

import UIKit
import Accelerate

/// Blur view
public class IMViewBlur {

    /// Add blur effect to view
    /// - parameter view: The blur effect should be used for itself.
    /// - parameter radius: The blur radius should be used when creating blur effect.
    /// - parameter duration: The transition duration,  default is`0.0`s
    public static func blur(in view: UIView, radius: CGFloat = 6.0, duration: TimeInterval = 0.0) {
        view.blur(withRadius: radius, duration: duration)
    }
    
    /// Remove blur effect from view
    /// - parameter view: The blur effect view should be removed from itself.
    /// - parameter duration: The transition duration,  default is`0.0`s
    public static func unBlur(from view: UIView, duration: TimeInterval = 0.0) {
        view.unBlur(duration)
    }
    
    /// View is blurred
    public static func isBlurred(for view: UIView) -> Bool {
        view.isBlurred
    }
}

private extension UIImage {
    
    /// Creates an image with blur effect based on itself.
    ///
    /// - parameter radius: The blur radius should be used when creating blur effect.
    /// - returns: An image with blur effect applied.
    ///
    /// - note: This method only works for CG-based image. The current image scale is kept.
    ///         For any non-CG-based image,  itself is returned.
    func blurred(withRadius radius: CGFloat) -> UIImage {
        guard let inputImage = cgImage else {
            assertionFailure("Blur only works for CG-based image.")
            return self
        }
        
        // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
        // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
        // if d is odd, use three box-blurs of size 'd', centered on the output pixel.
        // We will do blur on a resized image (*0.5), so the blur radius could be half as well.
        let targetRadius: CGFloat = {
            let targetRadius: CGFloat = floor(max($0, 2.0) * 3.0 * sqrt(2 * CGFloat.pi) / 4.0 + 0.5)
            if targetRadius.truncatingRemainder(dividingBy: 2.0) == 0 {
                return targetRadius + 1
            }
            return targetRadius
        }(radius)
        
        // Determine necessary iteration count by blur radius.
        let iterations: Int = {
            if $0 < 0.5 {
                return 1
            } else if $0 < 1.5 {
                return 2
            } else {
                return 3
            }
        }(radius)
         
        let targetSize = size
        
        func createEffectBuffer(_ context: CGContext) -> vImage_Buffer {
            vImage_Buffer(data: context.data,
                          height: vImagePixelCount(context.height),
                          width: vImagePixelCount(context.width),
                          rowBytes: context.bytesPerRow)
        }
        
        guard let inContext = beginContext(size: targetSize, scale: scale, inverting: true) else {
            assertionFailure(" Failed to create CGContext for blurring image.")
            return self
        }
        inContext.draw(inputImage, in: CGRect(x: 0, y: 0, width: Int(targetSize.width), height: Int(targetSize.height)))
        var inBuffer = vImage_Buffer(data: inContext.data,
                                     height: vImagePixelCount(inContext.height),
                                     width: vImagePixelCount(inContext.width),
                                     rowBytes: inContext.bytesPerRow)
        endContext()
        
        guard let outContext = beginContext(size: targetSize, scale: scale, inverting: false) else {
            assertionFailure("Failed to create CGcontext for blurring image.")
            return self
        }
        defer { endContext() }
        var outBuffer = vImage_Buffer(data: outContext.data,
                                      height: vImagePixelCount(outContext.height),
                                      width: vImagePixelCount(outContext.width),
                                      rowBytes: outContext.bytesPerRow)
        
        for _ in 0..<iterations {
            vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, nil, 0, 0, UInt32(targetRadius), UInt32(targetRadius), nil, vImage_Flags(kvImageEdgeExtend))
            // Next inBuffer should be the outButter of current iteration
            (inBuffer, outBuffer) = (outBuffer, inBuffer)
        }
        
        let result = outContext.makeImage().flatMap {
            UIImage(cgImage: $0, scale: scale, orientation: imageOrientation)
        }

        guard let outputImage = result else {
            assertionFailure("Can not make an blurred image within this context.")
            return self
        }
        return outputImage
    }
    
    private func beginContext(size: CGSize, scale: CGFloat, inverting: Bool = false) -> CGContext? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        if inverting { // If drawing a CGImage, we need to make context flipped.
            context.scaleBy(x: 1.0, y: -1.0)
            context.translateBy(x: 0, y: -size.height)
        }
        return context
    }
    
    private func endContext() {
        UIGraphicsEndImageContext()
    }
}

private extension UIView {
    
    private var blurOverlayKey: UnsafeRawPointer {
        UnsafeRawPointer(bitPattern: "com.IMViewBlur.blurOverlay".hashValue)!
    }
    
    private var blurOverlay: UIImageView? {
        get { objc_getAssociatedObject(self, blurOverlayKey) as? UIImageView }
        set { objc_setAssociatedObject(self, blurOverlayKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)  }
    }
    
    var isBlurred: Bool {
        blurOverlay != nil
    }
    
    func blur(withRadius radius: CGFloat, duration: TimeInterval) {
        let image = asImage().blurred(withRadius: radius)
        let blurOverlay = UIImageView(frame: frame)
        blurOverlay.image = image
        self.blurOverlay = blurOverlay

        if let superview = superview as? UIStackView,
            let index = (superview as UIStackView).arrangedSubviews.firstIndex(of: self) {
            removeFromSuperview()
            superview.insertArrangedSubview(blurOverlay, at: index)
        } else {
            UIView.transition(from: self,
                              to: blurOverlay,
                              duration: duration,
                              options: [.transitionCrossDissolve],
                              completion: nil)
            
        }
    }
    
    func unBlur(_ duration: TimeInterval) {
        guard let blurOverlay = blurOverlay else {
            return
        }
        self.blurOverlay = nil
        if let superview = blurOverlay.superview as? UIStackView,
            let index = (blurOverlay.superview as? UIStackView)?.arrangedSubviews.firstIndex(of: blurOverlay) {
            blurOverlay.removeFromSuperview()
            superview.insertArrangedSubview(self, at: index)
        } else {
            UIView.transition(from: blurOverlay,
                              to: self,
                              duration: duration,
                              options: [.transitionCrossDissolve],
                              completion: nil)
        }
    }
    
    private func asImage() -> UIImage {
        let rendererFormat = UIGraphicsImageRendererFormat.default()
        rendererFormat.opaque = false
        rendererFormat.scale = layer.contentsScale
        let renderer = UIGraphicsImageRenderer(size: bounds.size, format: rendererFormat)
        return renderer.image {
            layer.render(in: $0.cgContext)
        }
    }
}
