//
//  CourierDetail.swift
//  SafePick
//
//  Created by 김성현 on 10/09/2019.
//  Copyright © 2019 김성현. All rights reserved.
//

import Foundation

struct CourierData: Codable {
    
    var name: String
    
    var guName: String
    
    var address: String
    var legacyAddress: String
    var postalCode: String
    
    var phone: String
    
    var detailLocation: String
    
    var userGuide: String
    
    var latitude: String
    var longitude: String
    
    var contentID: String
    
    enum CodingKeys: String, CodingKey {
        case name = "COT_CONTS_NAME"
        case guName = "COT_GU_NAME"
        case address = "COT_ADDR_FULL_NEW"
        case legacyAddress = "COT_ADDR_FULL_OLD"
        case postalCode = "COT_NATION_BASE_AREA"
        case phone = "COT_TEL_NO"
        case detailLocation = "COT_VALUE_03"
        case userGuide = "COT_VALUE_02"
        case latitude = "COT_COORD_Y"
        case longitude = "COT_COORD_X"
        case contentID = "COT_CONTS_ID"
    }
}

struct ContentID: Codable {
    
    var string: String
    
    enum CodingKeys: String, CodingKey {
        case string = "COT_CONTS_ID"
    }
}

struct Head: Decodable {
    var head: [String: String]
}

struct Body<Element>: Decodable where Element: Decodable {
    var body: Element
}
