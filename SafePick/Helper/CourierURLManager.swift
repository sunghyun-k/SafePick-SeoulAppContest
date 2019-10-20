//
//  CourierURLManager.swift
//  SafePick
//
//  Created by 김성현 on 10/09/2019.
//  Copyright © 2019 김성현. All rights reserved.
//

import Foundation


class CourierURLManager {
    
    let themeID = "100180"
    var apiKey = "{API KEY}"
    
    let querySeperator = "&"
    
    init() {}
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    var themeIDParameter: Parameter {
        Parameter(name: "theme_id", value: themeID)
    }
    
    //MARK: URL
    
    func courierDetailURL(contentID: ContentID) -> URL {
        let parameters = [
            themeIDParameter,
            Parameter(name: "conts_id", value: contentID.string),
        ]
        return url(type: .poi, command: "getNewContentsDetail", parameters: parameters)
    }
    
    enum SearchType: Int {
        case distance = 0
        case name = 1
    }
    
    func allContentIdURL() -> URL {
        return url(type: .theme, command: "getContentsListAll", parameters: [Parameter(name: "theme_id", value: 100180)])
    }
    
    enum URLType {
        case poi
        case theme
        
        static let baseURLString = "https://map.seoul.go.kr/smgis/apps"
        
        var urlString: String {
            switch self {
            case .poi: return URLType.baseURLString + "/poi.do?"
            case .theme: return URLType.baseURLString + "/theme.do?"
            }
        }
    }
    
    func url(type: URLType, command: String, parameters: [Parameter]) -> URL {
        let string = url(type: type, command: command).absoluteString + querySeperator + urlString(from: parameters)
        return URL(string: string)!
    }
    
    func url(type: URLType, command: String) -> URL {
        let parameters = [
            Parameter(name: "cmd", value: command),
            Parameter(name: "key", value: apiKey)
        ]
        return url(type: type, parameters: parameters)
    }
    
    func url(type: URLType, parameters: [Parameter]) -> URL {
        return URL(string: type.urlString + urlString(from: parameters))!
    }
    
    func urlString(from parameters: [Parameter]) -> String {
        let parameterString = parameters.map { $0.urlString }
        return parameterString.joined(separator: querySeperator)
    }
}

struct Parameter {
    var name: String
    var value: String
    
    var urlString: String {
        let string = name + "=" + value
        return string.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
    
    init(name: String, value: String) {
        self.name = name
        self.value = value
    }
    
    init(name: String, value: Double) {
        self.name = name
        self.value = String(value)
    }
    
    init(name: String, value: Int) {
        self.name = name
        self.value = String(value)
    }
}
