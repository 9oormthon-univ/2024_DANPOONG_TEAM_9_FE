//
//  MyPageModel.swift
//  LOCC_FE
//
//  Created by 성호은 on 11/21/24.
//

import UIKit

struct MyPageResponse: Decodable {
    let code: String
    let data: UserData?
}

struct UserData: Decodable {
    let username: String
    let handle: String
    let profileImageUrl: URL
}
