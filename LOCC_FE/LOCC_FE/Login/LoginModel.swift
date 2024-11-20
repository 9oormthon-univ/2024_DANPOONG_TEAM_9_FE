//
//  LoginModel.swift
//  LOCC_FE
//
//  Created by 성호은 on 11/21/24.
//

import Foundation

struct LoginRequest: Encodable {
    let kakaoId: String
    let email: String
}

struct LoginResponse: Decodable {
    let code: String
    let message: String?
    let data: LoginData?
}

struct LoginData: Decodable {
    let username: String?
    let email: String?
    let accessToken: String?
}
