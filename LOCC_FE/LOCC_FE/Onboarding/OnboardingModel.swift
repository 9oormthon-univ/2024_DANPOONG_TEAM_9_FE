//
//  OnboardingModel.swift
//  LOCC_FE
//
//  Created by 성호은 on 11/22/24.
//

import Foundation

struct OnboardingData {
    var selectedCategories: [String] = []
    var selectedRegion: String? = nil
}

struct PreferencesRequest: Encodable {
    let categories: [String]
    let province: String
}

struct PreferencesResponse: Decodable {
    let code: String
    let message: String
}
