//
//  CourierInfoTableViewCell.swift
//  SafePick
//
//  Created by 김성현 on 30/08/2019.
//  Copyright © 2019 김성현. All rights reserved.
//

import UIKit

/// 무인 보관함 상세 정보 표시용 셀입니다.
class CourierInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!

    @IBOutlet weak var infoCellStackView: UIStackView!
    
    func updateContent(courier: (String, String, UIImage?)) {
        titleLabel.text = courier.0
        detailLabel.text = courier.1
        if let image = courier.2 {
            addIconToCell(image: image)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func addIconToCell(image: UIImage) {
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: 17, height: 17)
        accessoryView = imageView
        if #available(iOS 13.0, *) {
            setupColorAppearance()
        } else {
            setupLight()
        }
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
        accessoryView?.tintColor = UIColor(white: 1, alpha: 0.4)
    }
    
    func setupLight() {
        accessoryView?.tintColor = UIColor(white: 0, alpha: 0.2)
    }
    

}
