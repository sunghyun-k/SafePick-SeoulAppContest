//
//  CourierDetail.swift
//  SafePick
//
//  Created by 김성현 on 10/09/2019.
//  Copyright © 2019 김성현. All rights reserved.
//

import Foundation
import MapKit

class Courier: NSObject, Codable {
    
    private var data: CourierData
    
    init(data: CourierData) {
        self.data = data
    }
    
    var isFavorite: Bool {
        CourierManager.shared.favorites.contains(self)
    }
    
    var name: String {
        data.name
    }
    
    var guName: String {
        data.guName
    }
    
    var address: String {
        data.address
    }
    
    var legacyAddress: String {
        data.legacyAddress
    }
    
    var postalCode: String {
        data.postalCode
    }
    
    var phone: String {
        data.phone
    }
    
    var detailLocation: String {
        data.detailLocation.isEmpty ? "정보 없음" : data.detailLocation
    }
    
    var userGuide: String {
        // 읽기 쉽도록 개행합니다.
        return data.userGuide.replacingOccurrences(of: "→", with: "\n→").replacingOccurrences(of: "※", with: "\n※ ")
    }
    
    var contentID: String {
        data.contentID
    }
    
}

extension Courier: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: Double(data.latitude)!, longitude: Double(data.longitude)!)
    }
    
    var title: String? {
        return name
    }
}
