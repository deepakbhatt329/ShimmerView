import Foundation
import UIKit

open class ShimmerView: UIView, ShimmerSyncTarget, ShimmerReplicatorViewCell {
    internal static let animationKey = "ShimmerEffect"

    private(set) var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        return layer
    }()

    public private(set) var style: ShimmerViewStyle = .default

    private(set) var isAnimating: Bool = false

    public private(set) var effectBeginTime: CFTimeInterval = 0

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        layer.masksToBounds = true
        layer.addSublayer(gradientLayer)
        scaleGradientLayerToAspectFill()
    }

    public func startAnimating() {
        effectBeginTime = CACurrentMediaTime()
        isAnimating = true
        
        setupAnimation()
    }

    private func setupAnimation() {
        gradientLayer.removeAnimation(forKey: ShimmerView.animationKey)
        let animator = Animator(shimmerView: self)
        gradientLayer.colors = animator.interpolatedColors
        gradientLayer.add(animator.gradientLayerAnimation, forKey: ShimmerView.animationKey)
    }
    
    public func stopAnimating() {
        isAnimating = false
        gradientLayer.removeAnimation(forKey: ShimmerView.animationKey)
        gradientLayer.colors = nil
    }

    public func apply(style: ShimmerViewStyle) {
        self.style = style

        if isAnimating {
            setupAnimation()
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()

        scaleGradientLayerToAspectFill()

        if isAnimating {
            startAnimating()
        }
    }

    private func scaleGradientLayerToAspectFill() {
        if frame.width > frame.height {
            gradientLayer.frame.origin = CGPoint(x: 0, y: -(frame.width - frame.height)/2)
            gradientLayer.frame.size = CGSize(width: frame.width, height: frame.width)
        } else if frame.height > frame.width {
            gradientLayer.frame.origin = CGPoint(x: -(frame.height - frame.width)/2, y: 0)
            gradientLayer.frame.size = CGSize(width: frame.height, height: frame.height)
        } else {
            gradientLayer.frame = bounds
        }
    }
}
