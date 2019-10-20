//
//  MapService.swift
//  SafePick
//
//  Created by 김성현 on 03/09/2019.
//  Copyright © 2019 김성현. All rights reserved.
//

import Foundation
import MapKit

enum MapService: String, CaseIterable {
    case naver = "nmap://"
    case kakao = "kakaomap://"
    case google = "comgooglemaps://"
    case apple
    
    var name: String {
        switch self {
        case .naver: return "네이버 지도"
        case .kakao: return "카카오맵"
        case .google: return "Google 지도"
        case .apple: return "Apple 지도"
        }
    }
    
    var urlProtocol: URL {
        return URL(string: rawValue)!
    }
    
    func url(name: String, coordinate: CLLocationCoordinate2D) -> URL {
        let urlHostAllowedName = name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        switch self {
        case .naver:
            return URL(string: rawValue + "place?lat=\(coordinate.latitude)&lng=\(coordinate.longitude)&name=\(urlHostAllowedName)&appname=\(Bundle.main.bundleIdentifier!)")!
        case .kakao:
            return URL(string: rawValue + "look?p=\(coordinate.latitude),\(coordinate.longitude)")!
        case .google:
            return URL(string: rawValue + "?q=\(coordinate.latitude),\(coordinate.longitude)&center=\(coordinate.latitude),\(coordinate.longitude)")!
        case .apple:
            fatalError("Apple 지도는 URL로 열지 않습니다.")
        }
    }
    
    func open(name: String, coordinate: CLLocationCoordinate2D) {
        switch self {
        case .apple:
            openInAppleMaps(name: name, coordinate: coordinate)
        default:
            UIApplication.shared.open(url(name: name, coordinate: coordinate), options: [:], completionHandler: nil)
        }
    }
    
    var canOpen: Bool {
        switch self {
        case .apple:
            return true
        default:
            return UIApplication.shared.canOpenURL(urlProtocol)
        }
    }
    
    private func openInAppleMaps(name: String, coordinate: CLLocationCoordinate2D) {
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name
        mapItem.openInMaps(launchOptions: nil)
    }
}
