//
//  API+Extension.swift
//  LOCC_FE
//
//  Created by 성호은 on 11/18/24.
//

import Foundation
import Alamofire

// APIClient 클래스 정의
class APIClient {
    static let shared = APIClient()
    private init() {}
}

extension APIClient {
    
    // Base URL 설정
    private static let baseURL = "http://13.209.85.14"
    
    // 공통 헤더 생성 함수
    private static func getHeaders(forKakao token: String? = nil) -> HTTPHeaders {
        var headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        if let token = token {
            headers["Kakao-Authorization"] = "Bearer \(token)"
        }
        return headers
    }

    
    // 공통 GET 요청 함수
    static func getRequest<T: Decodable>(endpoint: String, token: String? = nil, completion: @escaping (Result<T, AFError>) -> Void) {
        let url = "\(baseURL)\(endpoint)"
        let headers = getHeaders(forKakao: token)
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }
    
    // 공통 GET 요청 함수 (parameters 추가)
    static func getRequest<T: Decodable>(endpoint: String, parameters: [String: Any]? = nil, token: String? = nil, completion: @escaping (Result<T, AFError>) -> Void) {
        let url = "\(baseURL)\(endpoint)"
        let headers = getHeaders(forKakao: token)
        
        AF.request(url, method: .get, parameters: parameters, headers: headers).responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }

    
    // 공통 POST 요청 함수
    static func postRequest<T: Decodable, U: Encodable>(endpoint: String, parameters: U, token: String? = nil, completion: @escaping (Result<T, AFError>) -> Void) {
        let url = "\(baseURL)\(endpoint)"
        let headers = getHeaders(forKakao: token)
        
        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers).responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }
    
    // 공통 POST 요청 함수 (parameters가 필요없을 때)
    static func postRequestWithoutParameters<T: Decodable>(endpoint: String, token: String? = nil, completion: @escaping (Result<T, AFError>) -> Void) {
        let url = "\(baseURL)\(endpoint)"
        let headers = getHeaders(forKakao: token)
        
        AF.request(url, method: .post, headers: headers).responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }
    
    // PUT 요청 함수
    static func putRequest<T: Decodable>(endpoint: String, parameters: Parameters? = nil, token: String, completion: @escaping (Result<T, AFError>) -> Void) {
       
        let url = "\(baseURL)\(endpoint)"
        let headers = getHeaders(forKakao: token)

        
        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }
    
    // 공통 DELETE 요청 함수
    static func deleteRequest<T: Decodable>(endpoint: String, token: String? = nil, completion: @escaping (Result<T, AFError>) -> Void) {
        let url = "\(baseURL)\(endpoint)"
        let headers = getHeaders(forKakao: token)
        
        AF.request(url, method: .delete, headers: headers).responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }
}
