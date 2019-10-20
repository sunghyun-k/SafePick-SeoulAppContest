//
//  CourierTableViewCell.swift
//  SafePick
//
//  Created by 박준희 on 30/08/2019.
//  Copyright © 2019 김성현. All rights reserved.
//

import UIKit

/// 즐겨찾기 하나의 정보를 나타내는 셀입니다.
class CourierTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    func updateContent(courier: Courier) {
        nameLabel.text = courier.name
        addressLabel.text = courier.address
    }
    
    func updateContentForNil() {
        nameLabel.text = "시설명 정보 없음"
        addressLabel.text = "주소 정보 없음"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
