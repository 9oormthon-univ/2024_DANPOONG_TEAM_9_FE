//
//  MyPageModel.swift
//  LOCC_FE
//
//  Created by 성호은 on 11/21/24.
//

import UIKit

// MARK: - 모델 정의
struct MyPageResponse: Codable {
    let code: String
    let data: UserData?
}

struct UserData: Codable {
    let username: String?
    let handle: String?
    let profileImageUrl: String?
    let savedCurations: [Curation]
    let savedStores: [Store]
}

struct Curation: Codable {
    let curationId: Int
    let title: String
    let subtitle: String
    let imageUrl: String?
}

struct Store: Codable {
    let storeId: Int
    let name: String
    let category: String
    let province: String
    let city: String
    let imageUrl: String?
    let rating: Double
    let reviewCount: Int
    let openTime: String?
    let closeTime: String?
    let businessStatus: String?
}
