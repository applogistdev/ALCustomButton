//
//  ALButton.swift
//  Turkeyana
//
//  Created by Unal Celik on 20.02.2020.
//  Copyright © 2020 Applogist. All rights reserved.
//

import UIKit

public class ALButton: UIControl {
    
    public enum ContentAlignment {
        case centered
        case spreaded
    }
    
    public enum IconPosition {
        case top
        case bottom
        case left
        case right
    }
    
    public enum GradientDirection {
        case vertical
        case horizontal
    }
    
    // MARK: - Properties
    public var icon: UIImage? { didSet { setNeedsLayout() } }
    public var text: String? { didSet { setNeedsLayout() } }
    
    public var isAnimatable: Bool = true {
        didSet {
            setupAnimatingPressActions()
        }
    }
    
    /// Default icon position is left
    private(set) var iconPosition: IconPosition = .left
    
    /// Default icon size
    private(set) var iconSize: CGFloat = 32 { didSet { setNeedsLayout() } }
    
    /// Default is not rounded
    private(set) var isRounded: Bool = false { didSet { setNeedsLayout() } }
    
    /// Corner Radius -> Default value is 8
    public var cornerRad: CGFloat {
        get {
            layer.cornerRadius
        } set {
            isRounded = false
            layer.cornerRadius = newValue
        }
    }
    
    /// Content margings
    private(set) var customContentMargins: UIEdgeInsets? { didSet { setNeedsLayout() } }
    
    /// Constraints for stackview
    private var centeredContentConstraints: [NSLayoutConstraint] = []
    private var spreadedContentConstraints: [NSLayoutConstraint] = []
    /// Current content alignment status. Spreaded is where icon is close to the edges. Centered is where icon is close to the label.
    private(set) var contentAlignment: ContentAlignment = .centered
    
    /// Title label's font --> Default is systemFont of size 18
    private(set) var textFont: UIFont = UIFont.systemFont(ofSize: 18) { didSet { setNeedsLayout() } }
    
    /// Title label's text alignment -> Default is centered.
    private(set) var titleAlignment: NSTextAlignment = .center { didSet { setNeedsLayout() } }
    
    /// Title label's text color --> Default is UIColor.black
    private(set) var titleTextColor: UIColor = .black { didSet { setNeedsLayout() } }
    
    /// Gradient Layer
    private var gradientLayer: CAGradientLayer?
    private var shouldApplyGradient: Bool = false { didSet { setNeedsLayout() } }
    
    private var gradientColors: [CGColor]?
    private var gradientDirection: GradientDirection?
    
    /// Shadow Properties
    private var shadowLayer: CAShapeLayer!
    private var shouldApplyShadow: Bool = false { didSet { setNeedsLayout() } }
    
    private var shadowColor: UIColor?
    private var shadowRadius: CGFloat?
    private var shadowOffset: CGSize?
    private var shadowOpacity: Float?
    private var innerShadows: Bool?
    
    

    // MARK: - Views
    
    private lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.isUserInteractionEnabled = false
        sv.distribution = .fill
        sv.spacing = 16
        sv.alignment = .center
        sv.axis = .horizontal
        sv.isLayoutMarginsRelativeArrangement = true
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private var iconImage: UIImageView? {
        if icon == nil {
            return nil
        }
        
        let i = UIImageView()
        i.image = icon
        i.isUserInteractionEnabled = false
        i.heightAnchor.constraint(equalToConstant: iconSize).isActive = true
        i.widthAnchor.constraint(equalTo: i.heightAnchor).isActive = true
        i.contentMode = .scaleAspectFit
        i.translatesAutoresizingMaskIntoConstraints = false
        return i
    }
    
    private var titleLabel: UILabel? {
        if text == nil {
            return nil
        }
        
        let t = UILabel()
        t.text = text
        t.font = textFont
        t.isUserInteractionEnabled = false
        t.textAlignment = titleAlignment
        t.textColor = titleTextColor
        t.adjustsFontSizeToFitWidth = true
        t.minimumScaleFactor = 0.6
        t.numberOfLines = 1
        t.sizeToFit()
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }
    
    
    // MARK: - View Life Cycle
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        setupStackView()
        setupMargins()
        roundEdges()
        applyShadow()
        applyGradientBackground()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupAll()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupAll()
    }
    
    
    // MARK: - Setup
    
    private func setupAll() {
        backgroundColor = .clear
        
        setupConstraints()
        defaultSetup()
        
        setupAnimatingPressActions()
    }
    
    private func setupAnimatingPressActions() {
        if isAnimatable {
            addTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter])
            addTarget(self, action: #selector(animateUp), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
        } else {
            removeTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter])
            removeTarget(self, action: #selector(animateUp), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
        }
    }
    
    private func defaultSetup() {
        backgroundColor = .clear
        
        /// Round edges with the default corner radius value of 8
        cornerRad = 8
        roundEdges()
    }
    
    private func setupConstraints() {
        addSubview(stackView)
        
        centeredContentConstraints = [
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 4),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor, constant: 4)
        ]
        
        spreadedContentConstraints = [
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(centeredContentConstraints)
        contentAlignment = .centered
        
        defaultSetup()
    }
    
    private func setupStackView() {
        stackView.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        let isVertical = (iconPosition == .bottom || iconPosition == .top)
        stackView.axis = isVertical ? .vertical : .horizontal
        stackView.distribution = isVertical ? .fillProportionally : .fill
        stackView.spacing = isVertical ? 4 : 16
        
        /// Add title label first, if icon is on the right or on the bottom
        if iconPosition == .bottom || iconPosition == .right {
            addToStack(titleLabel)
            addToStack(iconImage)
        } else {
            addToStack(iconImage)
            addToStack(titleLabel)
        }
    }
    
    private func addToStack(_ view: UIView?) {
        guard let view = view else { return }
        self.stackView.addArrangedSubview(view)
    }
    
    /// This should be called whenever an update happens in case of icon or text set.
    private func setupMargins() {
        if customContentMargins != nil {
            stackView.layoutMargins = customContentMargins!
            return
        }
        
        /// No borders and round edges if only icon will be displayed. --> Bordered icons istenirse üzerine sonradan tekrar eklenmeli.
        if icon != nil && text == nil {
            /// If only icon exists.
            stackView.layoutMargins = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        } else if text != nil && icon == nil {
            /// If only text exists.
            stackView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        } else {
            /// If both icon and text exists.
            stackView.layoutMargins = UIEdgeInsets(top: 8, left: 24, bottom: 8, right: 16)
        }
    }
    
    
    // MARK: - Configurations
    
    /// Set background color with pattern image
    /// - Parameter patternImage : Pattern image that will be used as a background color
    public func setBackgroundColorWith(patternImage: UIImage?) {
        guard let image = patternImage else { return }
        backgroundColor = UIColor(patternImage: image)
    }
    
    
    /// Set gradient background to the button
    /// - Parameters:
    ///   - colors: Gradient colors to be applied
    ///   - direction: Gradient direction. Default is horizontal
    public func setGradientBackground(with colors: [UIColor], direction: GradientDirection = .horizontal) {
        gradientColors = colors.map { $0.cgColor }
        gradientDirection = direction
        shouldApplyGradient = true
    }
    
    /// Apply gradient layer if properties are set but not applied yet.
    private func applyGradientBackground() {
        
        if shouldApplyGradient && gradientLayer == nil {
            gradientLayer = CAGradientLayer()
            gradientLayer!.frame = bounds
            gradientLayer!.cornerRadius = cornerRad
            
            gradientLayer!.colors = gradientColors
            gradientLayer!.startPoint = gradientDirection == .horizontal ? CGPoint(x: 0.0, y: 0.5) : CGPoint(x: 0.5, y: 0.0)
            gradientLayer!.endPoint = gradientDirection == .horizontal ? CGPoint(x: 1.0, y: 0.5) : CGPoint(x: 0.5, y: 1.0)
            
            if shadowLayer != nil {
                layer.insertSublayer(gradientLayer!, above: shadowLayer)
            } else {
                layer.insertSublayer(gradientLayer!, at: 0)
            }
        } else if shouldApplyGradient && gradientLayer != nil {
            gradientLayer!.cornerRadius = cornerRad
            gradientLayer!.removeAllAnimations()
        }
    }
    
    public func removeGradientBackground() {
        layer.sublayers?.removeAll(where: {
            $0 == gradientLayer
        })
        gradientLayer = nil
        shouldApplyGradient = false
    }
    
    /// Set shadow to button
    /// - Parameters:
    ///   - color: Shadow color -- Default: Black
    ///   - radius: Shadow radius -- Default: Button radius
    ///   - offset: Shadow offset -- Default: CGSize(x: 0, y: 0)
    ///   - opacity: Shadow opacity -- Default: 0.5
    ///   - innerShadows: Bool value if the inner shadows should be seen or not -- Default: false
    public func setShadow(color: UIColor = .black, radius: CGFloat? = nil, offset: CGSize? = nil, opacity: Float = 0.5, innerShadows: Bool = false) {
        
        self.shadowColor = color
        self.shadowRadius = radius
        self.shadowOffset = offset
        self.shadowOpacity = opacity
        self.innerShadows = innerShadows
        self.shouldApplyShadow = true
    }
    
    /// Apply shadow according to shadow properties.
    private func applyShadow() {
        layer.masksToBounds = false
        
        if shouldApplyShadow && shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            
            let shapePath = CGPath(roundedRect: bounds, cornerWidth: cornerRad, cornerHeight: cornerRad, transform: nil)
            
            shadowLayer.path = shapePath
            shadowLayer.fillColor = backgroundColor?.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowRadius = shadowRadius ?? 4
            shadowLayer.shadowColor = (shadowColor ?? .black).cgColor
            shadowLayer.shadowOffset = shadowOffset ?? .zero
            shadowLayer.shadowOpacity = shadowOpacity ?? 0.5
            
            layer.insertSublayer(shadowLayer, at: 0)
            
            /// If there's background color, there is no need to mask inner shadows.
            if backgroundColor == .clear && !(innerShadows ?? false) {
                let maskLayer = CAShapeLayer()
                maskLayer.path = { () -> UIBezierPath in
                    let path = UIBezierPath()
                    path.append(UIBezierPath(cgPath: shapePath))
                    let expandedRect = bounds.insetBy(dx: -40, dy: -40)
                    path.append(UIBezierPath(rect: expandedRect))
                    path.usesEvenOddFillRule = true
                    return path
                    }().cgPath
                
                maskLayer.fillRule = kCAFillRuleEvenOdd
                shadowLayer.mask = maskLayer
            }
            
        } else if shouldApplyShadow && shadowLayer != nil {     // Only update shadow path if shadowLayer exists.
            let shapePath = CGPath(roundedRect: bounds, cornerWidth: cornerRad, cornerHeight: cornerRad, transform: nil)
            
            shadowLayer.path = shapePath
            shadowLayer.shadowPath = shadowLayer.path
        }
    }
    
    public func removeShadows() {
        layer.sublayers?.removeAll(where: {
            $0 == shadowLayer
        })
        shadowLayer = nil
        shouldApplyShadow = false
    }
    
    /// Initialize button with text, icon or both at once
    /// - Parameters:
    ///   - icon: Icon image of the button
    ///   - text: Button title text
    public func setIconAndText(icon: UIImage?, text: String?) {
        self.icon = icon
        self.text = text
    }
    
    /// Set icon position
    /// - Parameter position: Icon position
    public func setIconPosition(_ position: IconPosition) {
        self.iconPosition = position
        setupStackView()
    }
    
    /// Set rounded
    /// - Parameter rounded: is rounded -> Default is true
    public func setRounded(_ rounded: Bool = true) {
        isRounded = rounded
    }
    
    /// Set content alignment
    /// - Parameter alignment: Alignment of the button content. Spreaded is where icon is close to the edges. Centered is where icon is close to the label.
    public func setContentAlignment(_ alignment: ContentAlignment) {
        if alignment == contentAlignment { return }
        
        switch alignment {
        case .centered:
            NSLayoutConstraint.deactivate(spreadedContentConstraints)
            NSLayoutConstraint.activate(centeredContentConstraints)
        case .spreaded:
            NSLayoutConstraint.deactivate(centeredContentConstraints)
            NSLayoutConstraint.activate(spreadedContentConstraints)
        }
        
        // Set the new value
        contentAlignment = alignment
    }
    
    /// Set title label's text alignment
    /// - Parameter alignment: NSTextAlignment
    public func setTextAlignment(_ alignment: NSTextAlignment) {
        titleAlignment = alignment
    }
    
    /// Set icon image tint color
    /// - Parameter color: Image tint color
    public func setImageTintColor(_ color: UIColor) {
        guard let icon = self.icon else { return }
        
        UIGraphicsBeginImageContextWithOptions(icon.size, false, icon.scale)
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0.0, y: icon.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(.normal)
        
        let rect = CGRect(x: 0.0, y: 0.0, width: icon.size.width, height: icon.size.height)
        context?.clip(to: rect, mask: icon.cgImage!)
        
        color.setFill()
        context?.fill(rect)
        
        let colorizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.icon = colorizedImage.withRenderingMode(.alwaysOriginal)
    }
    
    /// Set title text color
    /// - Parameter color: text color
    public func setTextColor(_ color: UIColor) {
        titleTextColor = color
    }
    
    /// Create border with specific width and color. ----> ! !  If using with "setBackgroundColorWith(patternImage:)", call this method after the setBackgroundColorWith(patternImage:)
    /// - Parameters:
    ///   - width: Border width
    ///   - color: Border color -- Default is tintColor of the button.
    public func setBorder(width: CGFloat, color: UIColor? = nil) {
        layer.borderWidth = width
        layer.borderColor = color?.cgColor ?? tintColor.cgColor
    }
    
    /// Set icon size. Aspect Ratio is always 1:1
    /// - Parameter size: Icon side length
    public func setIconSize(_ size: CGFloat) {
        iconSize = size
    }
    
    /// Set insets of stackview. If set to nil, uses default content margins according to content. 
    public func setInsets(_ insets: UIEdgeInsets?) {
        customContentMargins = insets
    }
    
    /// Set spacing between icon and button label
    /// - Parameter space: Space between items
    public func setSpacing(_ space: CGFloat) {
        stackView.spacing = space
    }
    
    /// Set text font
    /// - Parameters:
    ///   - font: Text Font
    public func setTextFont(_ font: UIFont?) {
        textFont = font ?? UIFont.systemFont(ofSize: 18)
    }
    
    /// Round edges
    private func roundEdges() {
        clipsToBounds = true
        
        if isRounded {
            layer.cornerRadius = self.frame.height / 2
        } else {
            layer.cornerRadius = cornerRad
        }
    }
    
    
    // MARK: - Tap Animations
    @objc private func animateDown(sender: UIControl) {
        animate(sender, transform: CGAffineTransform.identity.scaledBy(x: 0.97, y: 0.97))
    }
    
    @objc private func animateUp(sender: UIControl) {
        animate(sender, transform: .identity)
    }
    
    private func animate(_ button: UIControl, transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 3,
                       options: [.curveEaseInOut],
                       animations: {
                        button.transform = transform
        })
    }
}
