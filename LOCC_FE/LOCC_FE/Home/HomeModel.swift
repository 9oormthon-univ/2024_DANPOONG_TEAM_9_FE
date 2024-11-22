//
//  HomeModel.swift
//  LOCC_FE
//
//  Created by 성호은 on 11/21/24.
//

import Foundation

// Root Response
struct HomeResponse: Codable {
    let code: String
    let data: HomeData
}

// Nested Data
struct HomeData: Codable {
    let curations: [HomeCuration]
    let benefits: [HomeBenefit]
    let provinces: [HomeProvince]
    let reviews: [HomeReview]
    let advertisements: [HomeAdvertisement]
}

// Home Curation Model
struct HomeCuration: Codable {
    let curationId: Int
    let title: String
    let subtitle: String
    let imageUrl: String
}

// Home Benefit Model
struct HomeBenefit: Codable {
    let storeId: Int
    let name: String
    let rating: Float
    let province: String
    let city: String
    let imageUrl: String
}

// Home Province Model
struct HomeProvince: Codable {
    let province: String
    let imageUrl: String
}

// Home Review Model
struct HomeReview: Codable {
    let reviewId: Int
    let reviewerName: String
    let storeName: String
    let category: String
    let rating: Int
    let reviewCount: Int
    let imageUrl: String
}

// Home Advertisement Model
struct HomeAdvertisement: Codable {
    let advertisementId: Int
    let title: String
    let subtitle: String
    let imageUrl: String
}
