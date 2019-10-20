//
//  CourierData.swift
//  SafePick
//
//  Created by 김성현 on 01/09/2019.
//  Copyright © 2019 김성현. All rights reserved.
//

import Foundation

class CourierManager {
    
    static let shared = CourierManager()
    
    private var courierList = CourierList()
    
    private var maxRecentItemCount = 10
    
    private var favoritesContenIDs = [String]() {
        didSet {
            saveFavorites()
        }
    }
    private var recentItemsContentIDs = [String]() {
        didSet {
            saveRecentItems()
        }
    }
    
    static let FavoritesURL = DocumentDirectory.appendingPathComponent("favorites")
    
    static let RecentItemsURL = DocumentDirectory.appendingPathComponent("recentItems")
    
    init() {
        loadFavorites()
        loadRecentItems()
    }
    
    
    var allCouriers: [Courier] {
        return courierList.allCouriers
    }
    
    var favorites: [Courier?] {
        return favoritesContenIDs.map { courierList[$0] }
    }
    
    var recentItems: [Courier] {
        return recentItemsContentIDs.reversed().compactMap { courierList[$0] }
    }
    
    /// 데이터 업데이트
    func updateData(complition: ((Bool) -> Void)?) {
        courierList.updateData(complition: complition)
    }
    
    
    //MARK: 즐겨찾기
    
    /// 즐겨찾기에서 제거
    func removeFromFavorites(index: Int) {
        favoritesContenIDs.remove(at: index)
    }
    
    func removeFromFavorites(_ courier: Courier) {
        guard let index = favoritesContenIDs.firstIndex(of: courier.contentID) else {
            return
        }
        removeFromFavorites(index: index)
    }
    
    /// 이동
    func moveFavoriteItem(at originalIndex: Int, to destinationIndex: Int) {
        favoritesContenIDs.moveElement(at: originalIndex, to: destinationIndex)
    }
    
    /// 추가
    func addToFavorites(_ courier: Courier) {
        favoritesContenIDs.append(courier.contentID)
    }
    
    //MARK: 검색
    
    func filteredCouriers(for searchText: String) -> [Courier] {
        return courierList.filteredCouriers(for: searchText)
    }
    
    //MARK: 최근 항목 저장
    
    func addToRecentItems(_ courier: Courier) {
        if let index = recentItemsContentIDs.firstIndex(of: courier.contentID) {
            recentItemsContentIDs.moveElement(at: index, to: recentItemsContentIDs.endIndex - 1)
        } else {
            recentItemsContentIDs.append(courier.contentID)
        }
        
        while recentItemsContentIDs.count > maxRecentItemCount {
            recentItemsContentIDs.removeFirst()
        }
    }
    
    //MARK: 데이터 저장
    
    func saveFavorites() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(favoritesContenIDs)
            try data.write(to: CourierManager.FavoritesURL)
        } catch {
            print("즐겨찾기 저장 실패: \(error)")
            return
        }
    }
    
    func loadFavorites() {
        let decoder = PropertyListDecoder()
        do {
            let savedData = try Data(contentsOf: CourierManager.FavoritesURL)
            favoritesContenIDs = try decoder.decode([String].self, from: savedData)
        } catch {
            print("즐겨찾기 로드 실패: \(error)")
        }
    }
    
    
    
    func saveRecentItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(recentItemsContentIDs)
            try data.write(to: CourierManager.RecentItemsURL)
        } catch {
            print("최근 항목 저장 실패: \(error)")
            return
        }
    }
    
    func loadRecentItems() {
        let decoder = PropertyListDecoder()
        do {
            let savedData = try Data(contentsOf: CourierManager.RecentItemsURL)
            recentItemsContentIDs = try decoder.decode([String].self, from: savedData)
        } catch {
            print("최근 항목 로드 실패: \(error)")
            return
        }
    }
    
}

extension Array {
    mutating func moveElement(at originalIndex: Int, to destinationIndex: Int) {
        insert(remove(at: originalIndex), at: destinationIndex)
    }
}

extension Courier {
    func contains(_ input: String) -> Bool {
        return name.krSplited.contains(input) || address.krSplited.contains(input) || legacyAddress.krSplited.contains(input)
    }
}
