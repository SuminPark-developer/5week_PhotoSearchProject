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
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var id: UILabel!
    
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    override func viewDidLoad() {
//        super.viewDidLoad()
        loginInstance?.delegate = self
    }


    @IBAction func didTapKakaoLoginBtn(_ sender: UIButton) {
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print(error)
                
            }
            else {
                print("loginWithKakaoAccount() success.")
                //do something
                _ = oauthToken
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SecondVC")
                self.present(vc!, animated: true, completion: nil)
                
            }
            
        }
    }
    
    // 로그인에 성공한 경우 호출
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("Success login")
        getInfo()
    }
    
    // referesh token
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        loginInstance?.accessToken
    }
    
    // 로그아웃
    func oauth20ConnectionDidFinishDeleteToken() {
        print("log out")
    }
    
    // 모든 error
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("error = \(error.localizedDescription)")
    }
    
    @IBAction func login(_ sender: Any) {
        loginInstance?.requestThirdPartyLogin()
    }
    
    @IBAction func logout(_ sender: Any) {
        loginInstance?.requestDeleteToken()
    }
    
    // RESTful API, id가져오기
    func getInfo() {
      guard let isValidAccessToken = loginInstance?.isValidAccessTokenExpireTimeNow() else { return }
      
      if !isValidAccessToken {
        return
      }
      
      guard let tokenType = loginInstance?.tokenType else { return }
      guard let accessToken = loginInstance?.accessToken else { return }
        
      let urlStr = "https://openapi.naver.com/v1/nid/me"
      let url = URL(string: urlStr)!
      
      let authorization = "\(tokenType) \(accessToken)"
      
      let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
      
      req.responseJSON { response in
        guard let result = response.value as? [String: Any] else { return }
        guard let object = result["response"] as? [String: Any] else { return }
        guard let name = object["name"] as? String else { return }
        guard let email = object["email"] as? String else { return }
        guard let id = object["id"] as? String else {return}
        
        print(email)
        
        self.nameLabel.text = "\(name)"
        self.emailLabel.text = "\(email)"
        self.id.text = "\(id)"
      }
    }
    
    
}

