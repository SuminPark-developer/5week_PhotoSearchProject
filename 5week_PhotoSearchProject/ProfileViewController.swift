//
//  ProfileViewController.swift
//  5week_PhotoSearchProject
//
//  Created by sumin on 2021/10/13.
//

import UIKit

import KakaoSDKAuth
import KakaoSDKUser

import Alamofire
import NaverThirdPartyLogin

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    var loginMethod: String = "" // 카카오 로그인 or 네이버 로그인 구분을 위해.
    
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImageView.layer.cornerRadius = profileImageView.frame.width/2 // 이미지뷰 둥글게.
        profileImageView.clipsToBounds = true
        
        print(loginMethod)
        
        if loginMethod == "Kakao" {
            kakaoGetUserInfo()
            logoutButton.setBackgroundImage(UIImage(named: "kakao_logout_button.png"), for: UIControl.State.normal)
        }
        else if loginMethod == "Naver" {
            naverGetUserInfo()
            logoutButton.setBackgroundImage(UIImage(named: "naver_logout_button.png"), for: UIControl.State.normal)
        }
    }
    
    

    @IBAction func clickBackButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickLogoutButton(_ sender: UIButton) {
        if loginMethod == "Kakao" {} // 카카오 로그아웃 - 뭐 설정할 거 없는 듯.
        else if loginMethod == "Naver" {
            loginInstance?.requestDeleteToken() // 네이버 로그아웃
        }
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // 카카오 - RESTful API, 계정 정보 가져오기
    func kakaoGetUserInfo() {
            UserApi.shared.me() {(user, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("me() success.")
                    //do something
                    _ = user
                    self.nameLabel.text = user?.kakaoAccount?.profile?.nickname // 실명 - legalName(안되는듯.)
                    self.emailLabel.text = user?.kakaoAccount?.email // 이메일
                    self.nicknameLabel.text = user?.kakaoAccount?.profile?.nickname // 닉네임
                    
                    if let url = user?.kakaoAccount?.profile?.profileImageUrl,
                        let data = try? Data(contentsOf: url) {
                        self.profileImageView.image = UIImage(data: data)
                    }
                }
            }
    }
    
    // 네이버 - RESTful API, 계정 정보 가져오기
    func naverGetUserInfo() {
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
//        guard let id = object["id"] as? String else {return}
        guard let nickname = object["nickname"] as? String else {return}
        
        guard let profileImageString = object["profile_image"] as? String else {return}
        if let profileImageUrl = URL(string: profileImageString),
           let data = try? Data(contentsOf: profileImageUrl) {
            self.profileImageView.image = UIImage(data: data)
        }
//        let data = try? Data(contentsOf: url)
//        self.profileImageView.image = UIImage(data: data!)
        
        self.nameLabel.text = "\(name)"
        self.emailLabel.text = "\(email)"
        self.nicknameLabel.text = "\(nickname)"
      }
    }
        
}
