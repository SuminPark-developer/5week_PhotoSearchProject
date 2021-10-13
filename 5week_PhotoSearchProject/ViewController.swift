//
//  ViewController.swift
//  5week_PhotoSearchProject
//
//  Created by sumin on 2021/10/12.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser

import Alamofire
import NaverThirdPartyLogin

class ViewController: UIViewController, NaverThirdPartyLoginConnectionDelegate {
    
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    override func viewDidLoad() {
//        super.viewDidLoad()
        loginInstance?.delegate = self
        
        loginInstance?.requestDeleteToken() // 앱 시작시, 네이버 로그아웃
    }

    // VC에선 네비게이션바 안보이게 설정.
//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
//    }
//    // SecondVC에선 네비게이션바가 보이게 설정.
//    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
//    }

    // 카카오 로그인 버튼 클릭 시,
    @IBAction func didTapKakaoLoginBtn(_ sender: UIButton) {
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print(error)
                
            }
            else {
                print("loginWithKakaoAccount() success.")
                //do something
                _ = oauthToken
                
                let accessToken = oauthToken?.accessToken // 어세스 토큰
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SecondVC") as? SecondViewController
                vc?.loginMethod = "Kakao"
                self.navigationController?.pushViewController(vc!, animated: true)
                
            }
            
        }
    }
    
    // 네이버 로그인 - 성공한 경우 호출
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("Success login")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SecondVC") as? SecondViewController
        vc?.loginMethod = "Naver"
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    // 네이버 로그인 - referesh token
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        loginInstance?.accessToken
    }
    
    // 네이버 로그인 -  로그아웃
    func oauth20ConnectionDidFinishDeleteToken() {
        print("log out")
    }
    
    // 네이버 로그인 -  모든 error
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("error = \(error.localizedDescription)")
    }
    
    @IBAction func login(_ sender: Any) {
        loginInstance?.requestThirdPartyLogin()
    }
    
    @IBAction func logout(_ sender: Any) {
        loginInstance?.requestDeleteToken()
    }
    
    
}

