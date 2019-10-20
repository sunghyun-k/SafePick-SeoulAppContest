//
//  RoundedButton.swift
//  SafePick
//
//  Created by 김성현 on 03/09/2019.
//  Copyright © 2019 김성현. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {
    
    var defaultColor = UIColor.buttonGrayLight
    
    @IBInspectable var cornerRadius: CGFloat = 10.0 {
        didSet {
            setupButton()
        }
    }
    
    @IBInspectable var imageGap: CGFloat = 3 {
        didSet {
            setupButton()
        }
    }
    
    // 버튼의 타이틀이 변경될 때마다 아이콘을 중앙 정렬해야 합니다.
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        centerImageAndButton(gap: imageGap, imageOnTop: true)
    }
    
    var highlightedColor: UIColor!
    var touchDownAnimation: (() -> Void)!
    var touchUpAnimation: (() -> Void)!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    override func prepareForInterfaceBuilder() {
        setupButton()
    }
    
    func setupButton() {
        
        if #available(iOS 13.0, *) {
            setupColorAppearance()
        } else {
            setupLight()
        }

        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        
        setupSelectedColor()
        centerImageAndButton(gap: imageGap, imageOnTop: true)
        
        adjustsImageWhenHighlighted = false
    }
    
    func setupSelectedColor() {
        let touchDownHandler = {
            if self.backgroundColor != self.highlightedColor {
                self.backgroundColor = self.highlightedColor
            }
        }
        let touchUpHandler = {
            if self.backgroundColor != self.defaultColor {
                self.backgroundColor = self.defaultColor
            }
        }
        
        touchDownAnimation = { UIButton.animate(withDuration: 0.2, animations: touchDownHandler) }
        touchUpAnimation = { UIButton.animate(withDuration: 0.3, animations: touchUpHandler) }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touchDownAnimation()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        touchUpAnimation()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)

        if isTouchInside {
            touchDownAnimation()
        } else {
            touchUpAnimation()
        }
    }
    
    func centerImageAndButton(gap: CGFloat, imageOnTop: Bool) {
        guard let imageView = self.imageView, let titleLabel = self.titleLabel else { return }
        
        let sign: CGFloat = imageOnTop ? 1 : -1
        let imageSize = imageView.frame.size
        self.titleEdgeInsets = UIEdgeInsets(top: (imageSize.height + gap) * sign, left: -imageSize.width, bottom: 0, right: 0)
        let titleSize = titleLabel.bounds.size
        self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + gap) * sign, left: 0, bottom: 0, right: -titleSize.width)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 13.0, *) {
            guard let hasUserInterfaceStyleChanged = previousTraitCollection?.hasDifferentColorAppearance(comparedTo: traitCollection) else {
                return
            }
            if hasUserInterfaceStyleChanged {
                setupColorAppearance()
            }
        }
    }
    
    @available(iOS 13.0, *)
    func setupColorAppearance() {
        if traitCollection.userInterfaceStyle == .dark {
            setupDark()
        } else {
            setupLight()
        }
    }
    
    func setupDark() {
        defaultColor = UIColor.buttonGrayDark
        backgroundColor = defaultColor
        highlightedColor = defaultColor.lighter(percent: 0.5)
    }
    
    func setupLight() {
        defaultColor = UIColor.buttonGrayLight
        backgroundColor = defaultColor
        highlightedColor = defaultColor.darker(percent: 0.06)
    }
}
