//
//  CurationModel.swift
//  LOCC_FE
//
//  Created by 성호은 on 11/22/24.
//

import Foundation

struct CurationDetailResponse: Codable {
    let code: String
    let data: CurationDetailData
}

struct CurationDetailData: Codable {
    let curationInfo: CurationInfo
    let stores: [CurationStore]
    var bookmarked: Bool // 여기 추가
}

struct CurationInfo: Codable {
    let curationId: Int
    let title: String
    let subtitle: String
    let imageUrl: String
}

struct CurationStore: Codable {
    let storeInfo: StoreInfo
    let summary: String?
    var bookmarked: Bool // 수정: API 응답에서의 "bookmarked"와 매칭
}

struct StoreInfo: Codable {
    let storeId: Int
    let name: String
    let category: String
    let images: [String]
    let rating: Double
    let reviewCount: Int
    let openTime: String?
    let closeTime: String?
    let businessStatus: String
}

struct BookmarkToggleResponse: Codable {
    let code: String
    let data: BookmarkData
}

struct BookmarkData: Codable {
    var bookmarked: Bool
}
