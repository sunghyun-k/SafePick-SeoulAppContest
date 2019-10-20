//
//  UserTrackingButton.swift
//  SafePick
//
//  Created by 김성현 on 07/09/2019.
//  Copyright © 2019 김성현. All rights reserved.
//

import MapKit

class UserTrackingButton: UIButton {
    
    var cornerRadius: CGFloat = 8
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        setupImage()
        setupBlurView()
        setupLayer()
        
        if #available(iOS 13.0, *) {
            setupColorAppearance()
        }
    }
    
    func setupBlurView() {
        let blurView = UIVisualEffectView(frame: bounds)
        if #available(iOS 13.0, *) {
            blurView.effect = UIBlurEffect(style: .systemMaterial)
        } else {
            blurView.effect = UIBlurEffect(style: .prominent)
        }
        blurView.isUserInteractionEnabled = false
        blurView.layer.cornerRadius = cornerRadius
        blurView.layer.masksToBounds = true
        
        insertSubview(blurView, at: 0)
        
        if let imageView = imageView {
            bringSubviewToFront(imageView)
        }
        
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        blurView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        blurView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        blurView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    func setupImage() {
        setImage(#imageLiteral(resourceName: "location"), for: .normal)
        setImage(#imageLiteral(resourceName: "locationFill"), for: .selected)
        setImage(#imageLiteral(resourceName: "locationFill"), for: [.selected, .highlighted])
        
        let inset: CGFloat = 6
        imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func setupLayer() {
        
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 4
        layer.masksToBounds = false
        layer.cornerRadius = cornerRadius
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
        tintColor = .white
    }
    
    func setupLight() {
        tintColor = .redOrange
    }
}
