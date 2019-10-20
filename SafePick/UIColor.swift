//
//  UIColor.swift
//  SafePick
//
//  Created by 김성현 on 05/09/2019.
//  Copyright © 2019 김성현. All rights reserved.
//

import UIKit

extension UIColor {
    
    func lighter(percent: Double = 0.2) -> UIColor {
        return withBrightness(percent: 1 + percent)
    }
    
    func darker(percent: Double = 0.2) -> UIColor {
        return withBrightness(percent: 1 - percent)
    }
    
    private func withBrightness(percent: Double) -> UIColor {
        var cappedPercent = min(percent, 1.0)
        cappedPercent = max(0.0, percent)
        
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness * CGFloat(cappedPercent), alpha: alpha)
    }
    
    static let buttonGrayLight = UIColor(displayP3Red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
    static let buttonGrayDark = UIColor(red_255: 27, green: 28, blue: 30, alpha: 1)
    
    static let redOrange: UIColor = UIColor(red_255: 255, green: 92, blue: 71, alpha: 1)
    
    convenience init(red_255: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        self.init(displayP3Red: red_255 / 255, green: green / 255, blue: blue / 255, alpha: alpha)
    }
}
