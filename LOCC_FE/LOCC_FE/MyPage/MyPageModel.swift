//
//  MyPageModel.swift
//  LOCC_FE
//
//  Created by 성호은 on 11/21/24.
//

import Foundation

struct Response: Codable {
    let code: String
    let message: String?
    let data: UserData
}

struct UserData: Codable {
    let username: String
    let handle: String
    let profileImageUrl: URL
    let savedCurations: [Curation]
    let savedStores: [Store]
}

struct Curation: Codable {
    let curationId: Int
    let title: String
    let subtitle: String
    let imageUrl: URL
}

struct Store: Codable {
    let storeId: Int
    let name: String
    let category: String
    let province: String
    let city: String
    let imageUrl: URL
    let rating: Double
    let reviewCount: Int
    let openTime: String
    let closeTime: String
    let businessStatus: String
}
