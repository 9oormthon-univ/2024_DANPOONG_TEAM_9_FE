//
//  CurationModel.swift
//  LOCC_FE
//
//  Created by 성호은 on 11/22/24.
//

import Foundation

// 응답 모델
struct CurationDetailResponse: Codable {
    let code: String
    let data: CurationDetailData
}

struct CurationDetailData: Codable {
    let curationInfo: CurationInfo
    let stores: [CurationStore] // 이름 변경
}

struct CurationInfo: Codable {
    let curationId: Int
    let title: String
    let subtitle: String
    let imageUrl: String
}

struct CurationStore: Codable { // 이름 변경
    let storeInfo: StoreInfo
    var isBookmarked: Bool
    let distance: Int
    let summary: String
}

struct StoreInfo: Codable {
    let storeId: Int
    let name: String
    let category: String
    let province: String
    let city: String
    let imageUrl: String
    let rating: Double
    let reviewCount: Int
    let openTime: String? // null 값을 허용
    let closeTime: String? // null 값을 허용
    let businessStatus: String
}

struct BookmarkToggleResponse: Codable {
    let code: String
    let data: BookmarkData
}

struct BookmarkData: Codable {
    var bookmarked: Bool
}
