//
//  API+Extension.swift
//  LOCC_FE
//
//  Created by 성호은 on 11/18/24.
//

import Foundation
import Alamofire

// MARK: - HeaderType 열거형 추가
enum HeaderType {
    case kakaoAuthorization // 카카오 AccessToken
    case authorization       // 서버 AccessToken
}

// MARK: - APIClient 클래스 정의
class APIClient {
    static let shared = APIClient()
    private init() {}
}

extension APIClient {
    // Base URL 설정
    private static let baseURL = "http://13.209.85.14"
    
    // 공통 헤더 생성 함수
    private static func getHeaders(for token: String? = nil, headerType: HeaderType) -> HTTPHeaders {
        var headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        if let token = token {
            switch headerType {
            case .kakaoAuthorization:
                headers["Kakao-Authorization"] = "Bearer \(token)"
            case .authorization:
                headers["Authorization"] = "Bearer \(token)"
            }
        }
        return headers
    }
    
    // 공통 GET 요청 함수
    static func getRequest<T: Decodable>(endpoint: String, token: String? = nil, headerType: HeaderType, completion: @escaping (Result<T, AFError>) -> Void) {
        let url = "\(baseURL)\(endpoint)"
        let headers = getHeaders(for: token, headerType: headerType)
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }
    
    // 공통 GET 요청 함수 (parameters 추가)
    static func getRequest<T: Decodable>(endpoint: String, parameters: [String: Any]? = nil, token: String? = nil, headerType: HeaderType, completion: @escaping (Result<T, AFError>) -> Void) {
        let url = "\(baseURL)\(endpoint)"
        let headers = getHeaders(for: token, headerType: headerType)
        
        AF.request(url, method: .get, parameters: parameters, headers: headers).responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }
    
    // 공통 POST 요청 함수
    static func postRequest<T: Decodable, U: Encodable>(endpoint: String, parameters: U, token: String? = nil, headerType: HeaderType, completion: @escaping (Result<T, AFError>) -> Void) {
        let url = "\(baseURL)\(endpoint)"
        let headers = getHeaders(for: token, headerType: headerType)
        
        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers).responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }
    
    // 공통 POST 요청 함수 (parameters가 필요 없을 때)
    static func postRequestWithoutParameters<T: Decodable>(endpoint: String, token: String? = nil, headerType: HeaderType, completion: @escaping (Result<T, AFError>) -> Void) {
        let url = "\(baseURL)\(endpoint)"
        let headers = getHeaders(for: token, headerType: headerType)
        
        AF.request(url, method: .post, headers: headers).responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }
    
    // PUT 요청 함수
    static func putRequest<T: Decodable>(endpoint: String, parameters: Parameters? = nil, token: String, headerType: HeaderType, completion: @escaping (Result<T, AFError>) -> Void) {
        let url = "\(baseURL)\(endpoint)"
        let headers = getHeaders(for: token, headerType: headerType)
        
        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }
    
    // DELETE 요청 함수
    static func deleteRequest<T: Decodable>(endpoint: String, token: String? = nil, headerType: HeaderType, completion: @escaping (Result<T, AFError>) -> Void) {
        let url = "\(baseURL)\(endpoint)"
        let headers = getHeaders(for: token, headerType: headerType)
        
        AF.request(url, method: .delete, headers: headers).responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }
}
