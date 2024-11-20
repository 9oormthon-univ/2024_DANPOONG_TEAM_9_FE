//
//  LoginViewController.swift
//  LOCC_FE
//
//  Created by 성호은 on 11/18/24.
//

import UIKit
import KakaoSDKUser
import KakaoSDKAuth
import Alamofire

class LoginViewController: UIViewController {
    
    // button
    @IBOutlet weak var logo: UIButton!
    @IBOutlet weak var kakaoLoginBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // action
    @IBAction func kakaoButtonTapped(_ sender: Any) {
        if UserApi.isKakaoTalkLoginAvailable() {
            // 카카오톡 앱 로그인
            UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
                if let error = error {
                    print("KakaoTalk Login Failed: \(error.localizedDescription)")
                } else if let oauthToken = oauthToken {
                    print("KakaoTalk Login Success")
                    self?.fetchKakaoUserInfo(oauthToken: oauthToken.accessToken)
                }
            }
        } else {
            // 카카오 계정 로그인 (앱 미설치 시)
            UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
                if let error = error {
                    print("Kakao Account Login Failed: \(error.localizedDescription)")
                } else if let oauthToken = oauthToken {
                    print("Kakao Account Login Success")
                    self?.fetchKakaoUserInfo(oauthToken: oauthToken.accessToken)
                }
            }
        }
    }
    
    // MARK: - Fetch User Info
    func fetchKakaoUserInfo(oauthToken: String) {
        UserApi.shared.me() { [weak self] (user, error) in
            if let error = error {
                print("Failed to fetch Kakao user info: \(error.localizedDescription)")
            } else if let user = user {
                guard let userId = user.id else {
                    print("User ID not found")
                    return
                }
                let email = user.kakaoAccount?.email ?? "Unknown"
                print("Kakao User ID: \(userId), Email: \(email)")
                self?.loginToServer(userId: String(userId), email: email, oauthToken: oauthToken)
            }
        }
    }
    
    // MARK: - Login to Server
    func loginToServer(userId: String, email: String, oauthToken: String) {
        let endpoint = "/api/v1/auth/kakao"
        let parameters = LoginRequest(kakaoId: userId, email: email)
        
        APIClient.postRequest(endpoint: endpoint, parameters: parameters, token: oauthToken) { [weak self] (result: Result<LoginResponse, AFError>) in
            switch result {
            case .success(let loginResponse):
                print("Login Success: \(loginResponse)")
                if let accessToken = loginResponse.data?.accessToken {
                    UserDefaults.standard.set(accessToken, forKey: "accessToken")
                    self?.navigateToNextScreen(isRegistered: true)
                } else {
                    print("AccessToken is missing.")
                }
            case .failure(let error):
                if let data = error.underlyingError as? Data,
                   let jsonString = String(data: data, encoding: .utf8) {
                    print("Failed JSON: \(jsonString)")
                }
                print("Login Failed: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Navigation
    func navigateToNextScreen(isRegistered: Bool) {
        guard let onboardingVC = storyboard?.instantiateViewController(withIdentifier: "Onboarding1ViewController") as? Onboarding1ViewController else { return }
        onboardingVC.modalPresentationStyle = .fullScreen
        self.present(onboardingVC, animated: true, completion: nil)
    }
}
