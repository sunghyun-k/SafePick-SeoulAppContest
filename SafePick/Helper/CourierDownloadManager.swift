//
//  CourierDataManager.swift
//  SafePick
//
//  Created by 김성현 on 10/09/2019.
//  Copyright © 2019 김성현. All rights reserved.
//

import Foundation

class CourierDownloadManager {
    
    var urlManager = CourierURLManager()
    
    func downloadAllContentID() -> [ContentID]? {
        let url = urlManager.allContentIdURL()
        do {
            let data = try Data(contentsOf: url)
            return try decodeBody([ContentID].self, from: data)
        } catch {
            print(error)
            return nil
        }
    }
    
    func downloadCourier(contentID: ContentID) -> CourierData? {
        let url = urlManager.courierDetailURL(contentID: contentID)
        do {
            let data = try Data(contentsOf: url)
            return try decodeBody([CourierData].self, from: data).first!
        } catch {
            print(error)
            return nil
        }
    }
    
    private func decodeBody<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        let decoder = JSONDecoder()
        
        let head = try decoder.decode(Head.self, from: data).head
        let returnCode = head["RETCODE"]!
        guard returnCode == "0" else {
            throw NSError()
        }
        return try decoder.decode(Body<T>.self, from: data).body
    }
    
}
