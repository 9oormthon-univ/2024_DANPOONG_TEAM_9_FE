//
//  BookmarkModel.swift
//  LOCC_FE
//
//  Created by 성호은 on 11/22/24.
//

import Foundation

struct BookmarkResponse: Decodable {
    let code: String
    let message: String
    let data: BookmarkData
}

struct BookmarkData: Decodable {
    let bookmarked: Bool
}
