//
//  PastelView.swift
//  PokeDEX
//
//  Created by Kordian Ledzion on 24.05.2017.
//  Copyright © 2017 KordianLedzion. All rights reserved.
//

import UIKit

open class PastelView: UIView {
    
    private struct Animation {
        static let keyPath = "colors"
        static let key = "ColorChange"
    }
    
    @objc
    public enum PastelPoint: Int {
        case left
        case top
        case right
        case bottom
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
        
        var point: CGPoint {
            switch self {
            case .left: return CGPoint(x: 0.0, y: 0.5)
            case .top: return CGPoint(x: 0.5, y: 0.0)
            case .right: return CGPoint(x: 1.0, y: 0.5)
            case .bottom: return CGPoint(x: 0.5, y: 1.0)
            case .topLeft: return CGPoint(x: 0.0, y: 0.0)
            case .topRight: return CGPoint(x: 1.0, y: 0.0)
            case .bottomLeft: return CGPoint(x: 0.0, y: 1.0)
            case .bottomRight: return CGPoint(x: 1.0, y: 1.0)
            }
        }
    }
    
    // Custom Direction
    open var startPoint: CGPoint = PastelPoint.topRight.point
    open var endPoint: CGPoint = PastelPoint.bottomLeft.point
    
    open var startPastelPoint = PastelPoint.topRight {
        didSet {
            startPoint = startPastelPoint.point
        }
    }
    
    open var endPastelPoint = PastelPoint.bottomLeft {
        didSet {
            endPoint = endPastelPoint.point
        }
    }
    
    // Custom Duration
    open var animationDuration: TimeInterval = 5.0
    
    fileprivate let gradient = CAGradientLayer()
    private var currentGradient: Int = 0
    private var colors: [UIColor] = [UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
                                     UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),
                                     UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),
                                     UIColor(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),
                                     UIColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),
                                     UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
                                     UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)]
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds
    }
    
    public func startAnimation() {
        gradient.removeAllAnimations()
        setup()
        animateGradient()
    }
    
    fileprivate func setup() {
        gradient.frame = bounds
        gradient.colors = currentGradientSet()
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.drawsAsynchronously = true
        
        layer.insertSublayer(gradient, at: 0)
    }
    
    fileprivate func currentGradientSet() -> [CGColor] {
        guard colors.count > 0 else { return [] }
        return [colors[currentGradient % colors.count].cgColor,
                colors[(currentGradient + 1) % colors.count].cgColor]
    }
    
    public func setColors(_ colors: [UIColor]) {
        guard colors.count > 0 else { return }
        self.colors = colors
    }
    
    public func setPastelGradient(_ gradient: PastelGradient) {
        setColors(gradient.colors())
    }
    
    public func addcolor(_ color: UIColor) {
        self.colors.append(color)
    }
    
    func animateGradient() {
        currentGradient += 1
        let animation = CABasicAnimation(keyPath: Animation.keyPath)
        animation.duration = animationDuration
        animation.toValue = currentGradientSet()
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.delegate = self
        gradient.add(animation, forKey: Animation.key)
    }
    
    open override func removeFromSuperview() {
        super.removeFromSuperview()
        gradient.removeAllAnimations()
        gradient.removeFromSuperlayer()
    }
}

extension PastelView: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            gradient.colors = currentGradientSet()
            animateGradient()
        }
    }
}
