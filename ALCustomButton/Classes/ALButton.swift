//
//  ALButton.swift
//  Turkeyana
//
//  Created by Unal Celik on 20.02.2020.
//  Copyright © 2020 Applogist. All rights reserved.
//

import UIKit

public class ALButton: UIControl {
    
    public enum IconPosition {
        case top
        case bottom
        case left
        case right
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
    private(set) var isRounded: Bool = false
    
    /// Corner Radius -> Default value is 8
    public var cornerRadi: CGFloat {
        get {
            layer.cornerRadius
        } set {
            isRounded = false
            roundEdges()
        }
    }
    
    /// Title label's font --> Default is systemFont of size 18
    private(set) var textFont: UIFont = UIFont.systemFont(ofSize: 18) { didSet { setNeedsLayout() } }
    
    /// Title label's text alignment -> Default is centered.
    private(set) var titleAlignment: NSTextAlignment = .center { didSet { setNeedsLayout() } }
    
    /// Title label's text color --> Default is UIColor.black
    private(set) var titleTextColor: UIColor = .black { didSet { setNeedsLayout() } }
    
    
    /// Shadow Properties
    private var shadowLayer: CAShapeLayer!
    private var shouldApplyShadow: Bool = false
    
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
        t.minimumScaleFactor = 0.7
        t.numberOfLines = 0
        t.sizeToFit()
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }
    
    
    // MARK: - View Life Cycle
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        setupStackView()
        setupMargins()
        applyShadow()
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
    
    func setupAnimatingPressActions() {
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
        roundEdges()
        setBorder(width: 1, color: .lightGray)
    }
    
    private func setupConstraints() {
        addSubview(stackView)
        
        NSLayoutConstraint.activate ([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        defaultSetup()
    }
    
    private func setupStackView() {
        stackView.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        let isVertical = (iconPosition == .bottom || iconPosition == .top)
        stackView.axis = isVertical ? .vertical : .horizontal
        stackView.distribution = isVertical ? .fillEqually : .fill
        
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
    
    /// Clear background color to clear color.
    public func clearBackgroundColors() {
        backgroundColor = nil // == .clear
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
            
            let shapePath = CGPath(roundedRect: bounds, cornerWidth: cornerRadi, cornerHeight: cornerRadi, transform: nil)
            
            shadowLayer.path = shapePath
            shadowLayer.fillColor = backgroundColor?.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowRadius = shadowRadius ?? 4
            shadowLayer.shadowColor = (shadowColor ?? .black).cgColor
            shadowLayer.shadowOffset = shadowOffset ?? .zero
            shadowLayer.shadowOpacity = shadowOpacity ?? 0.5
            
            layer.insertSublayer(shadowLayer!, at: 0)
            
            /// If there's background color, there is no need to mask inner shadows.
            if backgroundColor != .none && !(innerShadows ?? false) {
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
        }
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
        self.isRounded = rounded
        roundEdges()
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
        self.titleTextColor = color
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
        self.iconSize = size
    }
    
    /// Set insets of stackview
    public func setInsets(top: CGFloat, right: CGFloat, bottom: CGFloat, left: CGFloat) {
        self.stackView.layoutMargins = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
    /// Set spacing between icon and button label
    /// - Parameter space: Space between items
    public func setSpacing(_ space: CGFloat) {
        self.stackView.spacing = space
    }
    
    /// Set text font
    /// - Parameters:
    ///   - font: Text Font
    public func setTextFont(_ font: UIFont?) {
        self.textFont = font ?? UIFont.systemFont(ofSize: 18)
    }
    
    /// Round edges
    private func roundEdges() {
        clipsToBounds = true
        
        if isRounded {
            layer.cornerRadius = self.frame.height / 2
        } else {
            layer.cornerRadius = 8  // Default value
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
