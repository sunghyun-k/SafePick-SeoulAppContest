//
//  CourierList.swift
//  SafePick
//
//  Created by 김성현 on 14/09/2019.
//  Copyright © 2019 김성현. All rights reserved.
//

import Foundation

let DocumentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

/// 모든 무인택배함의 정보를 가지는 구조
class CourierList {
    
    private var storage = [String: Courier]()
    
    private var updateQueue = DispatchQueue(label: "updateQueue")
    
    static let ArchiveURL = DocumentDirectory.appendingPathComponent("courierList")
    
    subscript(contentID: String) -> Courier? {
        get {
            return storage[contentID]
        }
    }
    
    init() {
        loadData()
    }
    
    var allCouriers: [Courier] {
        return Array(storage.values)
    }
    
    func updateData(complition: ((Bool) -> Void)? = nil) {
        let downloadManager = CourierDownloadManager()
        
        DispatchQueue.global().async {
            guard let contentIDs = downloadManager.downloadAllContentID() else {
                complition?(false)
                return
            }
            
            for contentID in contentIDs {
                guard let courierData = downloadManager.downloadCourier(contentID: contentID) else {
                    print("상세 정보 다운로드 실패 (contentID: \(contentID)")
                    continue
                }
                self.updateValue(Courier(data: courierData))
            }
            complition?(true)
            self.saveData()
        }
    }
    
    //MARK: 데이터 저장
    
    func saveData() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(storage)
            try data.write(to: CourierList.ArchiveURL)
        } catch {
            print("저장 실패: \(error)")
            return
        }
    }
    
    func loadData() {
        let decoder = PropertyListDecoder()
        do {
            let savedData = try Data(contentsOf: CourierList.ArchiveURL)
            storage = try decoder.decode([String: Courier].self, from: savedData)
        } catch {
            print("로드 실패: \(error)")
            return
        }
    }
    
    func filteredCouriers(for searchText: String) -> [Courier] {
        let krSplited = searchText.krSplited
        
        var result = [Courier]()
        
        for courier in storage.values where result.count < 30 {
            if courier.contains(krSplited) {
                result.append(courier)
            }
        }
        
        return result
    }
    
    private func updateValue(_ newCourier: Courier) {
        updateQueue.sync {
            storage[newCourier.contentID] = newCourier
        }
    }
}
